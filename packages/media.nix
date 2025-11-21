# Media Packages - Audio, video, and creative software
# Mix of simple packages and complex programs

{ config, pkgs, lib, ... }:

{
  # Media packages (simple installs)
  environment.systemPackages = with pkgs; [
    # Image editing/manipulation
    gimp
    inkscape
    krita
    
    # Media players
    vlc
    
    # Audio player
    strawberry
    
    # Audio tools
    pavucontrol
    playerctl
    pamixer
    
    # Office suite
    libreoffice
    
    # Utilities
    qbittorrent
    
    # Photo management
    shotwell
  ];
  
  # Media services and configuration
  security.rtkit.enable = true;  # For audio
}