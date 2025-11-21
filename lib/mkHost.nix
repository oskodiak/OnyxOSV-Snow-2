{ lib, nixpkgs, home-manager, rootPath ? ./. }:

let
  mkHost =
    { system ? "x86_64-linux"
    , hostname
    , profile
    , hardwareModule
    , userModules ? [ ]
    , extraModules ? [ ]
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
          (rootPath + "/system/core.nix")
          (rootPath + "/hardware/${hardwareModule}.nix")
          (rootPath + "/profiles/${profile}.nix")

          ## Home-Manager as a NixOS module
          home-manager.nixosModules.home-manager

          {
            networking.hostName = hostname;

            home-manager.useGlobalPkgs       = true;
            home-manager.useUserPackages     = true;
            home-manager.backupFileExtension = "backup";
          }
        ]
        ++ userModules    # e.g. ./users/oskodiak.nix
        ++ extraModules;  # for overrides if we ever need them
    };
in
{
  inherit mkHost;
}
