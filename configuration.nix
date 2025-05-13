{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./disks.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "pranburi";
    networkmanager.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_IDENTIFICATION = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_NUMERIC = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
      LC_NAME = "en_IE.UTF-8";
      LC_TIME = "en_IE.UTF-8";
      LC_ADDRESS = "en_IE.UTF-8";
      LC_TELEPHONE = "en_IE.UTF-8";
    };
  };

  environment = {
    pathsToLink = ["/libexec"];
    systemPackages = with pkgs; [
      curl
    ];
    persistence."/persistent" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/bluetooth"
        "/etc/NetworkManager/system-connections"
      ];
    };
  };

  users.users.op = {
    isNormalUser = true;
    description = "Otavio Pliger";
    initialPassword = "Hello, World!";
    extraGroups = [
      "wheel"
      "input"
      "audio"
      "video"
      "storage"
      "networkmanager"
    ];
  };

  services = {
    xserver = {
      enable = true;
      autorun = false;
      layout = "us";

      displayManager = {
        defaultSession = "none+i3";
      };

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3lock
          polybar
          xorg.xev
        ];
      };
    };

    btrfs = {
      autoScrub.enable = true;
      autoScrub.interval = "weekly";
      fileSystems = [ "/" ];
    };
  };

  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;
  };

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Opinionated: disable global registry
      flake-registry = "";

      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  console.keyMap = "us";
  time.timeZone = "Europe/Helsinki";
  system.stateVersion = "24.11";
}
