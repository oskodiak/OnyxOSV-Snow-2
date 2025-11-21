{ config, pkgs, lib, ... }:

{
  imports = [
    ../packages
  ];
  
  # SDDM display manager with Wayland support
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    autoNumlock = true;
  };
  
  # Sway as default session
  services.displayManager.defaultSession = "sway";

  # Sway window manager (configured via home-manager)
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };
  
  # Mouse cursor theme
  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  # Desktop-specific applications
  environment.systemPackages = with pkgs; [
    ghostty
    kitty
    brightnessctl
    networkmanagerapplet
    # Cursor themes
    adwaita-icon-theme
    gnome-themes-extra
  ];

  # System fonts
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
      serif = [ "Hack" ];
      sansSerif = [ "Hack" ];
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

  # Printing and network discovery
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}