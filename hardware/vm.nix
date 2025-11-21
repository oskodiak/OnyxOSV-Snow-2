{ config, lib, pkgs, ... }:

{
  ##  VM Hardware Profile (QEMU/KVM / virt-manager)

  boot = {
    # Initrd modules required for virtual machine storage and boot
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
      # Add "kvm-amd" automatically depending on CPU?
      # Users can override if needed.
    ];
  };

  ##  File Systems (required for vm-only testing)
  ##  These values match a standard NixOS installer layout.

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType  = "vfat";
  };

  swapDevices = [ ];

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
