{ config, lib, pkgs, modulesPath, ... }:

{
  # AMD graphics and hardware support
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    cpu.amd.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # AMD GPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Power management for AMD CPUs
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # AMD kernel bits
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci" "ehci_pci" "ahci"
      "usbhid" "usb_storage" "sd_mod"
    ];

    kernelModules = [ "kvm-amd" ];

    # Legacy SI/CIK toggles; safe defaults on newer cards
    kernelParams = [
      "amdgpu.si_support=1"
      "amdgpu.cik_support=1"
    ];
  };
}