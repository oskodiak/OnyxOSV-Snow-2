{ config, lib, pkgs, modulesPath, ... }:

{
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # NVIDIA X driver (Wayland via modesetting / nvidia-drm)
  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci" "ehci_pci" "ahci"
      "usbhid" "usb_storage" "sd_mod"
    ];

    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    kernelParams = [
      "nvidia-drm.modeset=1"
    ];
  };
}