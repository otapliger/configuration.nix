{ inputs, lib, config, pkgs, ... }:

{
  users = {
    users.op = {
      isNormalUser = true;
      description = "Otavio Pliger";
      initialPassword = "op";

      extraGroups = [
        "wheel"
        "input"
        "audio"
        "video"
        "storage"
        "networkmanager"
      ];
    };
  };

  home-manager = {
    users.op = ./op;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}