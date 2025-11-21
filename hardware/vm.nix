{ config, lib, pkgs, modulesPath, ... }:

{
  # Generic QEMU/KVM guest tuning
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "sr_mod"
      "virtio_blk"
    ];

    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  # VM guest services (Spice / QEMU)
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Optional VirtualBox guest integration (disabled by default)
  virtualisation.virtualbox.guest = {
    enable = lib.mkDefault false;
    seamless = false;
    clipboard = false;
  };
}