{ lib }:

# ------------------------------------------------------------------------------
#   OnyxOSV-Snow v2
#   Unified Host Constructor
#
#   mkHost {
#     username       = "oskodiak";
#     hostname       = "belial";
#     system         = "x86_64-linux";
#     profile        = "workstation";    # workstation | vm | laptop
#     hardwareModule = "amd";            # intel | amd | nvidia | nvidia-prime | vm
#     userModules    = [ ./users/oskodiak.nix ];
#     extraModules   = [ ];
#   }
#
#   This file does:
#     ✓ Merge system core
#     ✓ Merge hardware profile
#     ✓ Merge system profile (workstation/vm/laptop)
#     ✓ Merge desktop layer (swayfx, fonts, sddm, waybar, etc)
#     ✓ Merge per-user modules from the installer
#     ✗ NO filesystem logic
#     ✗ NO auto-detect
#     ✗ NO hardware-config.nix injection
#
#   Clean. Predictable. Snow-pure.
# ------------------------------------------------------------------------------

let
  # Quick helper to standardize input
  canonicalize = value:
    if builtins.isString value then value else
      throw "mkHost: Expected a string, got: ${builtins.typeOf value}";
in

{ config, pkgs, ... }:

let
  # We export a function, not a module
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
      # The final NixOS system entry
      ${uname} = lib.nixosSystem {
        inherit system;

        modules =
          [
            # Global core (bootloader, networking, security, nix settings)
            ../system/core.nix

            # Hardware selection (intel/amd/nvidia/vm)
            ../hardware/${hwName}.nix

            # Profile selection (workstation / vm / laptop)
            ../profiles/${profileName}.nix

            # Desktop layer (Snow's SwayFX + Waybar + themes)
            ../desktop/default.nix

            # Hostname module
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