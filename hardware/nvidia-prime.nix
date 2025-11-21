{ config, lib, pkgs, modulesPath, ... }:

{
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

        # You will override these bus IDs per machine if needed:
        # Run: lspci | grep -E "VGA|3D"
        # nvidia.busId = "PCI:1:0:0";
        # intel.busId  = "PCI:0:2:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Laptop-ish power defaults
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

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