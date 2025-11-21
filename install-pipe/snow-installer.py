#!/usr/bin/env python3
"""
OnyxOSV-Snow Textual Installer
Collects user info -> generates config -> runs nixos-rebuild switch --flake .#username
"""

from __future__ import annotations

import asyncio
import subprocess
from dataclasses import dataclass

from textual.app import App, ComposeResult
from textual.widgets import (
    Header,
    Footer,
    Input,
    Button,
    Label,
    Static,
    Select,
    ProgressBar,
    Log,
)
from textual.containers import Vertical, Horizontal, Container

# --- Data model -------------------------------------------------------------

@dataclass
class InstallConfig:
    username: str = ""
    hostname: str = ""
    github: str = ""
    email: str = ""
    profile: str = "workstation"
    hardware: str = "vm"


# --- Main App ---------------------------------------------------------------

class SnowInstaller(App):

    CSS = """
    Screen {
        align: center middle;
        background: #050712;  /* Arctic night backdrop */
    }

    #main-panel {
        width: 80%;
        height: 80%;
        border: round #6ba6ff;
        padding: 1 2;
        layout: vertical;
    }

    #title {
        content-align: center middle;
        color: #c9e6ff;
        text-style: bold;
    }

    #subtitle {
        content-align: center middle;
        color: #8fa2c2;
    }

    .field-label {
        width: 20;
        color: #9bb4e8;
    }

    .field-input {
        width: 40;
    }

    #buttons {
        height: 3;
        dock: bottom;
        content-align: center middle;
    }

    Button.primary {
        border: round #8f9bff;
        color: #e6f3ff;
    }

    Button.danger {
        border: round #ff6473;
        color: #ffd7dd;
    }

    #summary-box {
        height: 6;
        border: round #4e628f;
        padding: 0 1;
    }

    #log-panel {
        height: 100%;
        border: round #4e628f;
        padding: 0 1;
    }
    """

    BINDINGS = [
        ("ctrl+c", "quit", "Quit"),
    ]

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.config = InstallConfig()
        self._build_task: asyncio.Task | None = None

    # --- Screen layout ------------------------------------------------------

    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        with Container(id="main-panel"):
            yield Static("OnyxOSV-Snow Installer", id="title")
            yield Static("Professional NixOS for Workstations, Laptops and VMs", id="subtitle")
            yield Static("")  # spacer

            # Step 1: identity
            with Vertical():
                yield Static("User & System Identity", classes="section-title")

                with Horizontal():
                    yield Label("Username:", classes="field-label")
                    yield Input(placeholder="login name (e.g. oskodiak)", id="username", classes="field-input")
                with Horizontal():
                    yield Label("Hostname:", classes="field-label")
                    yield Input(placeholder="system hostname", id="hostname", classes="field-input")

                with Horizontal():
                    yield Label("GitHub:", classes="field-label")
                    yield Input(placeholder="github username (optional)", id="github", classes="field-input")
                with Horizontal():
                    yield Label("Email:", classes="field-label")
                    yield Input(placeholder="git email for this machine", id="email", classes="field-input")

            yield Static("")

            # Step 2: profile & hardware
            with Vertical():
                yield Static("Profile & Hardware", classes="section-title")

                with Horizontal():
                    yield Label("Profile:", classes="field-label")
                    yield Select(
                        options=[
                            ("Workstation", "workstation"),
                            ("Virtual Machine", "vm"),
                            ("Laptop", "laptop"),
                        ],
                        id="profile",
                    )

                with Horizontal():
                    yield Label("Hardware:", classes="field-label")
                    yield Select(
                        options=[
                            ("Intel (integrated)", "intel"),
                            ("AMD GPU", "amd"),
                            ("NVIDIA", "nvidia"),
                            ("NVIDIA Prime (hybrid)", "nvidia-prime"),
                            ("VM (virtio/virt)", "vm"),
                        ],
                        id="hardware",
                    )

            yield Static("")

            # Summary box
            with Container(id="summary-box"):
                yield Static("Configuration Summary", id="summary-title")
                self.summary_label = Static("", id="summary-content")
                yield self.summary_label

            # Log panel (hidden until build)
            with Container(id="log-panel"):
                self.progress_bar = ProgressBar(total=100)
                self.log_widget = Log()
                yield self.progress_bar
                yield self.log_widget

        with Horizontal(id="buttons"):
            yield Button("Generate Configs", id="generate", variant="primary")
            yield Button("Build System", id="build", variant="primary", disabled=True)
            yield Button("Quit", id="quit", variant="danger")
        yield Footer()

    # --- Helpers ------------------------------------------------------------

    def on_mount(self) -> None:
        # Set some defaults
        self.query_one("#profile", Select).value = "workstation"
        self.query_one("#hardware", Select).value = "vm"
        self._update_summary()
        # Hide log until needed
        self.progress_bar.visible = False
        self.log_widget.visible = False

    def _read_inputs(self) -> None:
        username = self.query_one("#username", Input).value.strip()
        hostname = self.query_one("#hostname", Input).value.strip()
        github = self.query_one("#github", Input).value.strip()
        email = self.query_one("#email", Input).value.strip()
        profile = self.query_one("#profile", Select).value
        hardware = self.query_one("#hardware", Select).value

        self.config = InstallConfig(
            username=username,
            hostname=hostname,
            github=github,
            email=email,
            profile=profile,
            hardware=hardware,
        )

    def _update_summary(self) -> None:
        self._read_inputs()
        c = self.config
        text = (
            f"  User:      {c.username or '<not set>'}\n"
            f"  Hostname:  {c.hostname or '<not set>'}\n"
            f"  Profile:   {c.profile}\n"
            f"  Hardware:  {c.hardware}\n"
            f"  GitHub:    {c.github or '<none>'}\n"
            f"  Email:     {c.email or '<none>'}"
        )
        self.summary_label.update(text)

    # --- Event handlers -----------------------------------------------------

    def on_input_changed(self, event: Input.Changed) -> None:
        self._update_summary()

    def on_select_changed(self, event: Select.Changed) -> None:
        self._update_summary()

    async def on_button_pressed(self, event: Button.Pressed) -> None:
        button_id = event.button.id

        if button_id == "quit":
            await self.action_quit()
            return

        if button_id == "generate":
            self._read_inputs()
            if not self.config.username or not self.config.hostname:
                await self.post_message(
                    Log.Message("Username and hostname are required.", self.log_widget)
                )
                return

            # Call your config generation routine here
            try:
                await self._generate_configs()
                self.query_one("#build", Button).disabled = False
            except Exception as e:
                self.log_widget.visible = True
                self.log_widget.write_line(f"[bold red]Config generation failed:[/bold red] {e}")
            return

        if button_id == "build":
            if self._build_task and not self._build_task.done():
                # Already building
                return
            self._build_task = asyncio.create_task(self._run_build())

    # --- Core actions -------------------------------------------------------

    async def _generate_configs(self) -> None:
        """Write Nix configs based on self.config.

        For now this just logs; you will wire this to your actual
        transform logic or re-use pieces from your existing transform.py.
        """
        self.log_widget.visible = True
        self.progress_bar.visible = True
        self.progress_bar.update(5)
        self.log_widget.write_line("[cyan]Generating configuration files...[/cyan]")

        # TODO: integrate your Nix file generation here.
        # e.g. write users/<username>.nix and patch flake.nix.

        # Simulate a bit of work
        await asyncio.sleep(0.5)
        self.progress_bar.update(20)
        self.log_widget.write_line(
            f"Using profile [bold]{self.config.profile}[/bold], hardware [bold]{self.config.hardware}[/bold]."
        )
        await asyncio.sleep(0.3)
        self.progress_bar.update(40)
        await asyncio.sleep(0.3)
        self.progress_bar.update(60)

        self.log_widget.write_line("[green]Configuration generation complete.[/green]")
        self.progress_bar.update(70)

    async def _run_build(self) -> None:
        """Run sudo nixos-rebuild switch --flake path:.#username with live log."""
        self._read_inputs()
        username = self.config.username
        if not username:
            self.log_widget.visible = True
            self.log_widget.write_line("[red]Cannot build: username is empty.[/red]")
            return

        self.log_widget.visible = True
        self.progress_bar.visible = True
        self.progress_bar.update(75)
        self.log_widget.write_line(
            f"[cyan]Starting system build for flake entry [bold].#{username}[/bold]...[/cyan]"
        )

        cmd = ["sudo", "nixos-rebuild", "switch", "--flake", f"path:.#{username}"]
        self.log_widget.write_line(f"[dim]Running: {' '.join(cmd)}[/dim]")

        # Run the process and stream output
        process = await asyncio.create_subprocess_exec(
            *cmd,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.STDOUT,
        )

        async for line in process.stdout:
            text = line.decode(errors="replace").rstrip()
            self.log_widget.write_line(text)

        rc = await process.wait()
        if rc == 0:
            self.progress_bar.update(100)
            self.log_widget.write_line("[bold green]Build completed successfully.[/bold green]")
        else:
            self.progress_bar.update(90)
            self.log_widget.write_line(f"[bold red]Build failed with exit code {rc}.[/bold red]")

    # --- Actions ------------------------------------------------------------

    async def action_quit(self) -> None:
        self.exit()


if __name__ == "__main__":
    app = SnowInstaller()
    app.run()
