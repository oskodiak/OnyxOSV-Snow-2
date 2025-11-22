{ config, lib, pkgs, ... }:

{
  ##  VM Hardware Profile (QEMU/KVM / virt-manager)
  ##  Imports hardware configuration if it exists, otherwise provides minimal VM config

  imports = lib.optionals (builtins.pathExists /etc/nixos/hardware-configuration.nix) [
    /etc/nixos/hardware-configuration.nix
  ];

  boot = {
    # Additional initrd modules for virtual machine storage and boot
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "virtio_blk"
      "sr_mod"
    ];

    # Runtime kernel modules for virtualization
    kernelModules = [
      "kvm-intel"
      "kvm-amd"  # Support both Intel and AMD
    ];
  };

  # Fallback filesystem configuration when hardware-configuration.nix doesn't exist
  # This will be overridden by hardware-configuration.nix when it exists
  fileSystems = lib.mkDefault {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = lib.mkDefault [ ];

  ##  QEMU/Spice Guest Integration (virt-manager best support)
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  ##  VirtualBox Disabled (we don't target it)
  virtualisation.virtualbox.guest = {
    enable = lib.mkForce false;
    seamless = false;
    clipboard = false;
  };
  ##  Display tuning specific to VM use
  ##  Ensures Sway/SwayFX runs correctly inside QEMU
  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";   # Fix invisible cursor in some qemu setups
    WLR_RENDERER = "pixman";         # Optional: fallback renderer for VMs
  };
}
