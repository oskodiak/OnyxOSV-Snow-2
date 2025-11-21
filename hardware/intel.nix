{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

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

  # Intel graphics drivers
  services.xserver.videoDrivers = [ "modesetting" ];
  
  # Intel power management
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
  
  # Intel kernel modules and optimizations
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      "i915.enable_fbc=1"    # Frame buffer compression
      "i915.enable_psr=1"    # Panel self refresh
    ];
  };

  # Default filesystem and network configuration
  swapDevices = lib.mkDefault [ ];
  networking.useDHCP = lib.mkDefault true;
}