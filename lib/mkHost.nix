{ lib }:

let
  canonicalize = value:
    if builtins.isString value then value else
      throw "mkHost: Expected a string, got: ${builtins.typeOf value}";
in

{ config, pkgs, ... }:

let
  mkHost = { username
           , hostname
           , system ? "x86_64-linux"
           , profile
           , hardwareModule
           , userModules ? [ ]
           , extraModules ? [ ]
           }:

    let
      uname = canonicalize username;
      hname = canonicalize hostname;
      profileName = canonicalize profile;
      hwName = canonicalize hardwareModule;

    in {
      ${uname} = lib.nixosSystem {
        inherit system;

        modules =
          [
            ../system/core.nix
            ../hardware/${hwName}.nix
            ../profiles/${profileName}.nix
            ../desktop/default.nix
            {
              networking.hostName = hname;
            }
          ]
          ++ userModules    # e.g. users/oskodiak.nix
          ++ extraModules;  # for advanced overrides

      };
    };

in
{
  inherit mkHost;
}
