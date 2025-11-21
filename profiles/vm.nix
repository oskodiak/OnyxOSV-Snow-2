{ config, pkgs, lib, ... }:

{
  imports = [
    ../packages
  ];

  #### Display manager / session ####

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };

  # SwayFX as default session
  services.displayManager.defaultSession = "sway";

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  #### Cursors / environment ####

  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE  = "24";
  };

  #### VM-focused package set (minimal) ####

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

  #### Fonts (simple, consistent) ####

  fonts = {
    packages = with pkgs; [
      noto-fonts
      hack-font
    ];

    fontconfig.defaultFonts = {
      monospace = [ "Hack" ];
    };
  };

  #### Portals for Wayland apps ####

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
