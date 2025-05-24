{ inputs, lib, config, pkgs, ... }:

{
  nixpkgs = {
    overlays = [
      (final: prev: {
        neovim = prev.neovim.overrideAttrs (oldAttrs: {
          postPatch = ''
            find runtime/colors ! -name 'default.vim' -type f -exec rm -f {} +
          '';
        });
      })
    ];
  };

  home = {
    username = "op";
    homeDirectory = "/home/op";

    packages = with pkgs; [
      # UI
      theme-vertex
      papirus-folders
      papirus-icon-theme
      adementary-theme
      # Development
      lua-language-server
      typescript-language-server
      jdt-language-server
      # Essentials
      alacritty
      zed-editor
      pcmanfm
      firefox
      neovim
      zellij
      feh
      imv
    ];

    persistence."/persist/home/op" = {
      directories = [
        "Stuff"
        "Music"
        "Videos"
        "Pictures"
        "Documents"
        ".config"
        ".local"
        ".ssh"
      ];

      files = [
        ".fehbg"
        ".bashrc"
        ".xinitrc"
        ".Xresources"
      ];

      allowOther = true;
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "otapliger";
      userEmail = "git@pliger.dev";
    };

    rofi = {
      enable = true;

      extraConfig = {
        case-sensitive = false;

        modi = [
          "drun"
          "run"
        ];
      };
    };

    firefox = {
      enable = true;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;

        Preferences = {
          "extensions.pocket.enabled" = {
            Value = false;
            Status = "locked";
          };
        };
      };
    };
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
