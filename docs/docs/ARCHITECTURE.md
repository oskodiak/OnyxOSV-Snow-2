# OnyxOSV-Snow Architecture

This document captures how the repository is currently organized and proposes a
few pragmatic upgrades to keep the installer workflow, flake, and module stack
coherent as the project grows.

## 1. Present layout at a glance

```
.
├── flake.nix          # Entry point that wires hardware+profile modules
├── install            # curl-able shell bootstrapper
├── system/            # Global NixOS knobs shared by every host
│   └── core.nix
├── hardware/          # Vendor-specific hardware fragments
├── profiles/          # High-level roles (workstation, vm, ...)
├── hosts/             # Per-host configuration modules
├── users/             # User-specific configuration modules
├── desktop/           # Desktop environment components
│   ├── sway.nix       # SwayFX window manager
│   ├── waybar.nix     # Status bar
│   ├── terminals/     # Ghostty and Kitty terminal configs
│   ├── shell/         # ZSH and Powerlevel10k configuration
│   └── default.nix    # Complete desktop stack
├── packages/          # Organized package collections
├── lib/               # Utility functions and helpers
└── install-pipe/      # Installation pipeline components
    ├── bootstrap.py   # curses-based configuration capture
    └── transform.py   # Applies the captured selections to the tree
```

The flow today is:

1. `install` performs dependency checks, clones the repo, and launches
   `install-pipe/bootstrap.py` against the user's TTY.
2. `install-pipe/bootstrap.py` collects the high-level answers and invokes `install-pipe/transform.py`.
3. `install-pipe/transform.py` writes host and user stubs plus patches `flake.nix` so the new
   host can be targeted with `nixos-rebuild --flake .#<hostname>`.
4. `flake.nix` composes `system/core.nix`, a hardware module, a role module
   from `profiles/`, and the complete desktop environment to produce a bootable configuration.

## 2. Recommended structure improvements

| Area | Recommendation | Benefit |
|------|----------------|---------|
| System layering | Split `system/` into `modules/` (reusable tweaks), `roles/` (desktop/server personas) and `hosts/` (per-machine overrides). Keep `core.nix` minimal and import from these subtrees. | Makes it trivial to test modules in isolation and reason about precedence. |
| Hardware | Introduce a `hardware/default.nix` that selects the correct vendor module, then allow host modules to override via `imports = [ ../hardware/${vendor}.nix ];`. | Simplifies `transform.py` and keeps the flake symmetric across hosts. |
| Hosts | Store every host as `hosts/<name>/default.nix` (as `transform.py` already does) and expose a helper `lib/mkHost.nix` for consistent imports. | Eliminates bespoke boilerplate per host while keeping overrides close to the hardware. |
| Users | Keep immutable user modules inside `users/` and surface them through `home-manager` in the flake instead of letting `transform.py` patch the root. | Encourages reuse (shared dotfiles) and protects the flake from runaway templating. |
| Installer | Move `bootstrap.py`, `transform.py`, and helper utilities into `installer/` with a Python package layout (`installer/__main__.py`, `installer/tui.py`, `installer/project.py`). Keep the top-level `install` script as a thin shim. | Makes testing easier (`python -m installer`) and keeps the repo root focused on the flake. |
| Testing | Add a `tests/flake` directory with `nix flake check` inputs for each profile plus a `pytest` harness for installer code. | Provides immediate feedback when changing modules or the CLI. |

## 3. Suggested next steps

1. **Stabilize directories** – keep empty-but-documented `hosts/` and `users/`
   directories in git (see `hosts/README.md` and `users/README.md`) so future
   automation lands in a predictable location.
2. **Extract installer library** – refactor `bootstrap.py` into smaller modules
   (input validation, renderers, subprocess glue) so the curses UI can be unit
   tested without launching `curses.wrapper`.
3. **Automate host registration** – instead of string splicing inside
   `transform.py`, consider a declarative `hosts/default.nix` that returns an
   attribute set of hosts. `flake.nix` can then do `inherit (import ./hosts) workstation vm ...`.
4. **Document the layering** – keep the README's architecture section short and
   point to this document for details so newcomers have a canonical reference.

Keeping these boundaries crisp will make it much easier to reason about the
installer pipeline and give you room to expand into additional host roles,
user personas, or service bundles without accumulating debt.