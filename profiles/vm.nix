{ config, pkgs, lib, ... }:

{
  # SDDM display manager with VM optimizations
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };
  
  # Sway as default session
  services.displayManager.defaultSession = "sway";
  
  
  # Mouse cursor theme
  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  # Sway window manager (configured via home-manager)
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  # Minimal application set
  environment.systemPackages = with pkgs; [
    ghostty
    firefox
    git
    vim
    htop
    tree
    adwaita-icon-theme
    gnome-themes-extra
  ];

  # Basic fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      hack-font
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Hack" ];
    };
  };

  # Desktop integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}