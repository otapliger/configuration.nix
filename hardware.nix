{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

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
        mkdir /mnt
        mount -o space_cache=v2,compress=zstd,discard=async,commit=120,noatime /dev/mapper/cryptroot /mnt
        btrfs su de /mnt/root
        btrfs su sn /mnt/blank /mnt/root
      '';
    };

    kernelModules = [
      "kvm-amd"
    ];
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
