{ config, pkgs, lib, ... }:

{
  #### Core ####
  system.stateVersion = "25.05";

  #### Boot (EFI only, no GRUB) ####
  boot.loader = {
    systemd-boot.enable       = lib.mkDefault true;
    efi.canTouchEfiVariables  = lib.mkDefault true;

    grub = {
      enable        = lib.mkForce false;
      device        = lib.mkForce "nodev";
      mirroredBoots = lib.mkForce [ ];
    };
  };

  #### Networking ####
  networking = {
    networkmanager.enable = true;
    firewall.enable       = true;
  };

  #### Time & Locale ####
  time.timeZone = "America/Los_Angeles";

  i18n = {
    defaultLocale    = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
    ];
  };

  console.keyMap = "us";

  services.xserver = {
    xkb.layout  = "us";
    xkb.variant = "";
  };

  #### Audio / Services ####

  services = {
    # Essential desktop services
    libinput.enable = true;                    # Input handling (mouse/touchpad)
    gvfs.enable = true;                        # File manager mounting
    gnome.gnome-keyring.enable = true;         # Password/credential management
    blueman.enable = true;                     # Bluetooth GUI management
    tumbler.enable = true;                     # Image thumbnails
    fstrim.enable = true;                      # SSD optimization
    
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication      = true;
        KbdInteractiveAuthentication = false;
      };
    };

    pipewire = {
      enable          = true;
      alsa.enable     = true;
      alsa.support32Bit = true;
      pulse.enable    = true;
      wireplumber.enable = true;

      extraConfig.pipewire."92-low-latency" = {
        context.properties = {
          default.clock.rate         = 48000;
          default.clock.quantum      = 256;
          default.clock.min-quantum  = 256;
          default.clock.max-quantum  = 256;
        };
      };
    };
  };

  #### Security ####
  security = {
    rtkit.enable = true;

    polkit.enable = true;
    polkit.extraConfig = ''
      polkit.addRule(function (action, subject) {
        if (subject.isInGroup("users") && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
        )) {
          return polkit.Result.YES;
        }
      });
    '';

    # Enable swaylock authentication
    pam.services.swaylock = {
      text = "auth include login";
    };
  };

  #### Shell ####
  programs.zsh.enable = true;

  #### Hardware ####
  hardware = {
    graphics.enable = true;                    # GPU acceleration
    bluetooth.enable = true;                   # Bluetooth support
    bluetooth.powerOnBoot = true;              # Auto-start Bluetooth
    enableRedistributableFirmware = true;     # Non-free firmware
  };

  #### Home-Manager ####
  home-manager = {
    useGlobalPkgs      = true;
    useUserPackages    = true;
    backupFileExtension = "backup";
  };

  #### Nix / GC ####
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;
    };
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  #### Base System Packages ####
  environment.systemPackages = with pkgs; [
    curl
    git
    vim
    htop
    tree
    python3
  ];
}
