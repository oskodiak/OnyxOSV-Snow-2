{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

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

  # AMD GPU drivers
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  # Power management for AMD CPUs
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };
  
  # AMD specific kernel modules
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "amdgpu.si_support=1"
      "amdgpu.cik_support=1"
    ];
  };

  # Filesystem configuration

  swapDevices = lib.mkDefault [ ];
  networking.useDHCP = lib.mkDefault true;
}