{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # NVIDIA Prime (Optimus laptop) hardware support
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = lib.mkDefault true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      
      prime = {
        sync.enable = true;
        # Configure these based on hardware detection:
        # Run: lspci | grep -E "VGA|3D"
        # nvidia.busId = "PCI:1:0:0";
        # intel.busId = "PCI:0:2:0";
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  # Hybrid graphics drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Power management for laptops
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
  
  # Hybrid graphics kernel modules
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelParams = [
      "nvidia-drm.modeset=1"
    ];
  };

  # Filesystem configuration

  swapDevices = lib.mkDefault [ ];
  networking.useDHCP = lib.mkDefault true;
}