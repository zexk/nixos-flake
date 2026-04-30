{ inputs, config, ... }:
{
  flake.nixosConfigurations.main-nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules =
      (builtins.attrValues config.flake.nixosModules)
      ++ [
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
              imports =
                (builtins.attrValues config.flake.homeModules)
                ++ [
                  inputs.oxwm.homeManagerModules.default
                  ./_home.nix
                ];
            };
          };
        }
      ];
  };
}
