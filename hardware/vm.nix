{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # VM kernel modules
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # VM guest services
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # VirtualBox guest integration
  virtualisation.virtualbox.guest = {
    enable = lib.mkDefault false;
    seamless = false;
    clipboard = false;
  };


  # VM filesystem layout
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  # Network configuration
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
}