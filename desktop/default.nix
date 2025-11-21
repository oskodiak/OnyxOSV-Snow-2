# Desktop Configuration

{ config, pkgs, lib, ... }:

{
  imports = [
    ./sway.nix
    ./waybar.nix
    ./rofi.nix
    ./swaync.nix
    ./fastfetch.nix
    ./terminals/ghostty.nix
    ./terminals/kitty.nix
    ./shell/zsh.nix
  ];
  
  # Enable home-manager services
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
  
  # Desktop environment services
  services = {
    # Clipboard manager
    cliphist.enable = true;
  };
  
  # Desktop applications and utilities
  home.packages = with pkgs; [
    # Wayland utilities
    wl-clipboard
    wlr-randr
    wayland-utils
    
    # Screenshot and screen recording
    grim
    slurp
    swappy
    wf-recorder
    
    # System monitoring and control
    brightnessctl
    playerctl
    pamixer
    
    
    # Image viewer
    imv
    
    # PDF viewer
    zathura
    
    # Media player
    vlc
    
    # Archive manager
    file-roller
    
    # Theme and appearance
    adwaita-icon-theme
    hicolor-icon-theme
    
    # Fonts
    hack-font
    nerd-fonts.hack
    
    # Shell utilities
    bat
    eza
  ];
  
  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  
  # Qt theme configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  
  # Environment variables
  home.sessionVariables = {
    # Wayland
    WAYLAND_DISPLAY = "wayland-1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    
    # Theme
    GTK_THEME = "Adwaita:dark";
    
    # Editor
    EDITOR = "nvim";
    VISUAL = "nvim";
    
    # Browser
    BROWSER = "firefox";
  };
  
  # XDG user directories
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
    };
    
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "application/pdf" = "zathura.desktop";
        "image/png" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";
        "inode/directory" = "thunar.desktop";
      };
    };
  };
}
