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

  #### Laptop desktop applications ####

  environment.systemPackages = with pkgs; [
    ghostty
    firefox
    brightnessctl
    networkmanagerapplet
    powertop
    acpi

    adwaita-icon-theme
    gnome-themes-extra
  ];

  #### Fonts ####

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

  #### Portals ####

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  #### Laptop-specific services ####

  # Modern power-profiles daemon (preferred on many laptops)
  services.power-profiles-daemon.enable = true;

  # Optional: TLP if you want aggressive tuning (can conflict with power-profiles-daemon,
  # so normally you pick one or the other. Leave commented if you prefer PPD.)
  # services.tlp.enable = true;

  # Touchpad / input tuning (Wayland compositors use libinput directly,
  # but these options still apply at system level for some apps)
  services.libinput.enable = true;

  # Suspend / lid behaviour can be tuned here if you want:
  # services.logind.lidSwitch = "suspend";
}
