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
      dmenu-rs
      pcmanfm
      firefox
      neovim
      zellij
      feh
    ];
    persistence."/persistent/home/op" = {
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

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "otapliger";
      userEmail = "git@pliger.dev";
    };
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.11";
}
