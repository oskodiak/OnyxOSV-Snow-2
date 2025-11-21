{ config, pkgs, lib, ... }:

{
  # Core system configuration
  system.stateVersion = "25.05";
  
  # Boot configuration defaults: prefer systemd-boot
  boot.loader = {
    systemd-boot.enable = lib.mkDefault true;
    efi.canTouchEfiVariables = lib.mkDefault true;
    grub = {
      enable = lib.mkForce false;
      device = lib.mkForce "nodev";
      mirroredBoots = lib.mkForce [ ];
    };
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Localization
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Essential services
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
      };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 256;
          default.clock.min-quantum = 256;
          default.clock.max-quantum = 256;
        };
      };
    };
  };

  # Shell configuration
  programs.zsh.enable = true;

  # Security
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (
              subject.isInGroup("users")
                  && (
                      action.id == "org.freedesktop.login1.reboot" ||
                      action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                      action.id == "org.freedesktop.login1.power-off" ||
                      action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                  )
              )
          {
              return polkit.Result.YES;
          }
      })
    '';
  };

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    htop
    tree
    python3
  ];

  nixpkgs.config.allowUnfree = true;
}
