{ config, lib, pkgs, modulesPath, ... }:

{
  # Intel hardware support
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Intel graphics driver (modesetting is usually best on Wayland)
  services.xserver.videoDrivers = [ "modesetting" ];

  # Intel power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  # Intel kernel modules and tunables
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci" "ehci_pci" "ahci"
      "usbhid" "usb_storage" "sd_mod"
    ];

    kernelModules = [ "kvm-intel" ];

    kernelParams = [
      "i915.enable_fbc=1"    # frame buffer compression
      "i915.enable_psr=1"    # panel self refresh
    ];
  };
}