# Gaming Packages - Steam and Lutris with proper configuration
# Steam needs special configuration, Lutris is simple install

{ config, pkgs, lib, ... }:

{
  # Gaming programs that need special setup
  programs = {
    # Steam with all the necessary configuration  
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
    
    # GameMode for performance optimization
    gamemode.enable = true;
  };
  
  # Simple gaming packages
  environment.systemPackages = with pkgs; [
    lutris          # Game launcher (simple install)
    mangohud        # Gaming overlay
    discord         # Gaming communication
  ];
  
  # Gaming hardware support
  hardware = {
    # Steam hardware support  
    steam-hardware.enable = true;
    
    # Xbox controller support
    xpadneo.enable = true;
  };
  
  
  # Gaming-specific system configuration
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel"; 
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
}