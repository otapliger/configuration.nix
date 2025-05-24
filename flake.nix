{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    impermanence,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      pranburi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          ./users
          ./systems/pranburi
          ./configuration.nix
        ];
      };
    };
  };
}
