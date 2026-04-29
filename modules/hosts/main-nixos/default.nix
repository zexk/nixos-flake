{ inputs, ... }:
{
  flake.nixosConfigurations.main-nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      (inputs.import-tree ../../_nixos)
      ./_configuration.nix
      inputs.nix-index-database.nixosModules.nix-index
      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          backupFileExtension = "bck";
          useGlobalPkgs = true;
          useUserPackages = true;
          users.zexk = {
            imports = [
              inputs.oxwm.homeManagerModules.default
              (inputs.import-tree ../../_home-manager)
              ./_home.nix
            ];
          };
        };
      }
    ];
  };
}
