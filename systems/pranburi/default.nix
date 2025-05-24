{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "usbhid"
        "thunderbolt"
        "usb_storage"
        "xhci_pci"
        "sd_mod"
      ];

      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zpool/root@blank
      '';
    };

    kernelModules = [
      "kvm-amd"
    ];
  };

  networking = {
    hostId = "c4a6v9te";
    hostName = "pranburi";
    networkmanager.enable = true;
    firewall.enable = true;
    useDHCP = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
