# Complex Programs - Need special configuration, services, or enabling
# These require programs.* or services.* configuration

{ config, pkgs, lib, ... }:

{
  # Programs that need enabling at system level
  programs = {
    
    # Neovim with professional configuration
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    
    # GPG with proper setup
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
    
    
    # Firefox with policies
    firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };
    };
    
    
    # Direnv for development environments
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  
  # Services that need to be enabled
  services = {
    # Bluetooth
    blueman.enable = true;
    
    # Flatpak for additional software
    flatpak.enable = true;
    
    # Location services
    geoclue2.enable = true;
  };
  
  # Hardware support that needs enabling
  hardware = {
    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    
    # OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    
    # Firmware
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };
}