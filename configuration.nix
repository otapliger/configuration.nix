{ inputs, lib, config, pkgs, ... }:

{
  boot.loader.grub = {
    zfsSupport = true;
    efiSupport = true;
    device = "nodev";
  };

  i18n = {
    defaultLocale = "en_IE.UTF-8";

    extraLocaleSettings = {
      LC_TIME = "en_IE.UTF-8";
      LC_NAME = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
      LC_NUMERIC = "en_IE.UTF-8";
      LC_ADDRESS = "en_IE.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_TELEPHONE = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
      LC_IDENTIFICATION = "en_IE.UTF-8";
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "ComicShannsMono"
      ];
    })
  ];

  environment = {
    pathsToLink = ["/libexec"];

    systemPackages = with pkgs; [
      curl
    ];

    persistence."/persist" = {
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

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  sound.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    wireplumber = {
      enable = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      auto-optimise-store = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Opinionated: disable global registry
      flake-registry = "";

      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    gc = {
      dates = "weekly";
      options = "--delete-older-than 2w";
      automatic = true;
    };

    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  console.keyMap = "us";
  time.timeZone = "Europe/Helsinki";
  system.stateVersion = "25.05";
}
