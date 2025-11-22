{ config, pkgs, lib, ... }:

let
  username = "oskodiak";
in
{
  ##############################
  ##     SYSTEM USER           ##
  ##############################

  users.users.${username} = {
    isNormalUser = true;
    description  = "Kodiak";
    home         = "/home/${username}";
    shell        = pkgs.zsh;

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "docker"
    ];
  };

  ##############################
  ##     HOME MANAGER         ##
  ##############################

  home-manager.users.${username} = { pkgs, ... }: {
    home.username      = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion  = "25.05";

    imports = [
      ../desktop/default.nix
    ];

    programs.git = {
      enable    = true;
      settings = {
        user = {
          name = "oskodiak";
          email = "oskodiak@proton.me";
        };
      };  
    };
  };
}
