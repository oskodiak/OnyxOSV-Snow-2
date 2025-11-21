# Ghostty Terminal Configuration
# Modern, fast terminal with professional setup

{ config, pkgs, lib, ... }:

{

  programs.ghostty = {
    enable = true;
    
    settings = {
      # Font configuration
      font-family = "Hack";
      font-size = 12;
      font-feature = [
        "ss01"  # Alternative styling for 'a'
        "ss02"  # Alternative styling for 'g'
        "zero"  # Slashed zero
        "cv14"  # Alternative styling for '3'
      ];
      
      # Theme and colors - Wallpaper coordinated
      background = "#2d1b4e";           # Deep purple from wallpaper
      foreground = "#f0efff";           # Light/white from wallpaper
      cursor-color = "#4c5be8";         # Snowflake blue
      selection-background = "#8a7ee8"; # Light purple
      selection-foreground = "#f0efff"; # Light/white
      
      # Transparency
      background-opacity = 0.85;
      
      # Color palette - OnyxOSV-Snow theme
      palette = [
        # Normal colors
        "0=#2d1b4e"  # black (deep purple)
        "1=#eb4d4b"  # red  
        "2=#4c5be8"  # green (snowflake blue)
        "3=#b8b3e6"  # yellow (light purple)
        "4=#4c5be8"  # blue (snowflake blue)
        "5=#8a7ee8"  # magenta (medium purple)
        "6=#6b5ce6"  # cyan (border purple)
        "7=#f0efff"  # white (light)
        
        # Bright colors  
        "8=#6b5ce6"  # bright black (border purple)
        "9=#eb4d4b"  # bright red
        "10=#4c5be8" # bright green (snowflake blue)
        "11=#b8b3e6" # bright yellow (light purple)
        "12=#4c5be8" # bright blue (snowflake blue)
        "13=#8a7ee8" # bright magenta (medium purple)
        "14=#6b5ce6" # bright cyan (border purple)
        "15=#f0efff" # bright white (light)
      ];
      
      # Window settings
      window-decoration = false;
      window-padding-x = 8;
      window-padding-y = 8;
      
      # Terminal behavior
      confirm-close-surface = false;
      quit-after-last-window-closed = true;
      
      # Shell integration
      shell-integration = "detect";
      
      # Copy/paste
      copy-on-select = false;
      
      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;
      
      # Scrollback
      scrollback-limit = 10000;
      
      # Mouse
      mouse-hide-while-typing = true;
      
      # Key bindings
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_surface"
        "ctrl+shift+n=new_window"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+zero=reset_font_size"
        "ctrl+shift+f=toggle_fullscreen"
      ];
    };
  };
}