# Simple Packages - Just install, no special configuration needed
# These can be installed with environment.systemPackages

{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # System utilities
    htop
    tree
    ripgrep
    fd
    eza
    bat
    fzf
    jq
    wget
    unzip
    zip
    
    # File managers
    yazi              # Terminal file manager
    xfce.thunar       # GUI file manager
    xfce.thunar-volman     # Volume management
    xfce.thunar-archive-plugin  # Archive support
    xfce.thunar-media-tags-plugin  # Media file tags
    
    # Network tools
    curl
    nmap
    iperf3
    speedtest-cli
    
    # System monitoring
    neofetch
    fastfetch
    bottom
    iotop
    
    # Archive tools
    p7zip
    unrar
    
    # Text editors (simple)
    nano
    
    # Image viewers
    imv
    feh
    
    # PDF viewers  
    zathura
    
    
    # Screenshot tools
    grim
    slurp
    swappy
    wf-recorder
    
    # Clipboard tools
    wl-clipboard
    
    # System tools
    pciutils
    usbutils
    lshw
    dmidecode
    
    # Archive manager
    file-roller
    
    # Basic calculators
    calc
    bc
    
    # Password tools
    pwgen
    
    # Git (simple install)
    git
    
    # Terminal multiplexers
    tmux
    screen
  ];
}