# Host creation helper

{ lib, nixpkgs, home-manager, rootPath ? ./.. }:

let
  # Create a host configuration with consistent imports and structure
  mkHost = { hostname, system ? "x86_64-linux", hardwareModule, profile, userModules ? [], extraModules ? [] }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Base system
        (rootPath + "/system/core.nix")
        
        # Hardware configuration
        (rootPath + "/hardware/${hardwareModule}.nix")
        
        # Profile (workstation, vm, etc.)
        (rootPath + "/profiles/${profile}.nix")
        
        # Home manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        
        # Host-specific config
        {
          networking.hostName = hostname;
        }
        
        # User modules
        ] ++ userModules
          ++ extraModules;
    };
in
{
  inherit mkHost;
  
  # Helper to create multiple hosts from a simple attribute set
  mkHosts = hosts: 
    lib.mapAttrs (name: config: 
      mkHost (config // { hostname = name; })
    ) hosts;
}