# Development Tools - Programming and development software
# Mix of simple packages and complex programs with configuration

{ config, pkgs, lib, ... }:

{
  # Development programs that need configuration
  programs = {
    # Direnv for development environments
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
  
  # Development packages (simple installs)
  environment.systemPackages = with pkgs; [
    # Editors/IDEs
    vscode
    
    # Version control
    git-lfs
    gh              # GitHub CLI
    
    # Languages
    python3
    nodejs
    rustc
    cargo
    go
    
    # Build tools
    gnumake
    cmake
    gcc
    
    # Database tools
    sqlite
    
    # Container tools
    docker-compose
    
    # API tools
    postman
    
    # Text processing
    pandoc
  ];
  
  # Development services
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };
}