# Fastfetch Configuration

{ config, pkgs, lib, ... }:

{
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        color = {
          keys = "36";      # Cyan for keys - professional blue tone
          output = "97";    # Bright white for output
        };
        separator = " ▶ ";  # Clean arrow separator
      };

      logo = {
        # Will use ASCII logo until custom logo is created
        type = "builtin";
        source = "nixos";
        height = 10;
        padding = {
          top = 1;
          left = 2;
        };
      };

      modules = [
        "break"
        # System Information Section
        {
          type = "os";
          key = "System";
          keyColor = "36";
        }
        {
          type = "command";
          key = " ├─ OnyxOSV-Snow";
          keyColor = "36";
          text = "echo v1.0-dev";
        }
        {
          type = "kernel"; 
          key = " ├─ Kernel";
          keyColor = "36";
        }
        {
          type = "packages";
          key = " ├─ Packages";
          keyColor = "36";
        }
        {
          type = "shell";
          key = " └─ Shell";
          keyColor = "36";
        }
        
        "break"
        # Desktop Environment Section
        {
          type = "wm";
          key = "Desktop";
          keyColor = "35";  # Magenta for desktop section
        }
        {
          type = "wmtheme";
          key = " ├─ Theme";
          keyColor = "35";
        }
        {
          type = "icons";
          key = " ├─ Icons"; 
          keyColor = "35";
        }
        {
          type = "cursor";
          key = " ├─ Cursor";
          keyColor = "35";
        }
        {
          type = "terminal";
          key = " ├─ Terminal";
          keyColor = "35";
        }
        {
          type = "terminalfont";
          key = " └─ Font";
          keyColor = "35";
        }

        "break"
        # Hardware Section
        {
          type = "host";
          format = "{5} {1} {2}";
          key = "Hardware";
          keyColor = "33";  # Yellow for hardware
        }
        {
          type = "cpu";
          format = "{1} ({3}) @ {7} GHz";
          key = " ├─ CPU";
          keyColor = "33";
        }
        {
          type = "gpu";
          format = "{1} {2}";
          key = " ├─ GPU";
          keyColor = "33";
        }
        {
          type = "memory";
          key = " ├─ Memory";
          keyColor = "33";
        }
        {
          type = "disk";
          key = " ├─ Storage";
          keyColor = "33";
        }
        {
          type = "monitor";
          key = " └─ Display";
          keyColor = "33";
        }

        "break"
        # Status Section
        {
          type = "uptime";
          key = "Uptime";
          keyColor = "32";  # Green for status
        }
      ];
    };
  };
}