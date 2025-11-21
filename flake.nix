{
  description = "OnyxOSV-Snow v2 - NixOS distribution for workstation / VM / laptop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    hostHelpers = import ./lib/mkHost.nix {
      inherit (nixpkgs) lib;
      inherit nixpkgs home-manager;
      rootPath = ./.;
    };
  in {
    nixosConfigurations = with hostHelpers; {
      # Sample dev hosts (can be removed once the installer is fully wired)

      workstation = mkHost {
        inherit system;
        hostname       = "workstation";
        hardwareModule = "amd";
        profile        = "workstation";
        # userModules   = [ ./users/your-user.nix ];
      };

      vm = mkHost {
        inherit system;
        hostname       = "vm";
        hardwareModule = "vm";
        profile        = "vm";
        # userModules   = [ ./users/your-user.nix ];
      };
    };
  };
}