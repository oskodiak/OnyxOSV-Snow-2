{ config, pkgs, lib, ... }:

let
  username = "oskodiak";
in
{
  ## System user account
  users.users.${username} = {
    isNormalUser = true;
    description  = "Kodiak";
    home         = "/home/${username}";
    shell        = pkgs.zsh;

    extraGroups = [
      "wheel"          # sudo
      "networkmanager" # networking
      "audio"
      "video"
      "docker"         # optional
    ];
  };

  ## Home-Manager user configuration
  home-manager.users.${username} = { pkgs, ... }: {
    home.username      = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion  = "25.05";

    imports = [
      ../desktop/default.nix
    ];

    programs.git = {
      enable    = true;
      userName  = "oskodiak";
      userEmail = "oskodiak@proton.me";
    };

    ## (user packages later)
  };
}
