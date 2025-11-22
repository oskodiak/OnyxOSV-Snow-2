{ config, pkgs, lib, ... }:

{
  ##############################
  ##  DISPLAY SERVER + SDDM   ##
  ##############################

  services.xserver = {
    enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
  };

  # Tell NixOS which session SDDM should start
  services.displayManager.defaultSession = "sway";

  ##############################
  ##        SWAYFX WM         ##
  ##############################

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE  = "24";
  };

  ##############################
  ##    DESKTOP PACKAGES      ##
  ##############################

  environment.systemPackages = with pkgs; [
    ghostty
    kitty
    firefox
    brightnessctl
    networkmanagerapplet

    # GTK themes / icons
    adwaita-icon-theme
    gnome-themes-extra
  ];

  ##############################
  ##          FONTS           ##
  ##############################

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      fira-code
      fira-code-symbols
      jetbrains-mono
      hack-font
    ];

    fontconfig.defaultFonts = {
      serif      = [ "Hack" ];
      sansSerif  = [ "Hack" ];
      monospace  = [ "Hack" ];
    };
  };

  ##############################
  ##         PORTALS          ##
  ##############################

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  ##############################
  ##     PRINT / NETWORK      ##
  ##############################

  services.printing.enable = true;

  services.avahi = {
    enable       = true;
    nssmdns4     = true;
    openFirewall = true;
  };
}
