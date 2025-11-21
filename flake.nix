{
  description = "OnyxOSV-Snow v2 - NixOS distribution for workstation / laptop";

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

    inherit (hostHelpers) mkHost;
  in {
    nixosConfigurations = {
      # Dev VM: Belial / workstation profile, VM hardware
      oskodiak = mkHost {
        inherit system;
        hostname       = "belial-vm";   # or "belial", your call
        profile        = "workstation"; # uses profiles/workstation.nix
        hardwareModule = "vm";          # uses hardware/vm.nix
        userModules    = [ ./users/oskodiak.nix ];
      };

      # (You can keep/remove other sample hosts later)
    };
  };
}
