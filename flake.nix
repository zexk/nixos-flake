{
  description = "zexk's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    llama.url = "github:ggml-org/llama.cpp";
    llm-agents.url = "github:numtide/llm-agents.nix";

    nur.url = "github:nix-community/NUR";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    agenix.url = "github:ryantm/agenix";

    oxwm.url = "github:tonybanters/oxwm";

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nur,
      nix-index-database,
      home-manager,
      flake-utils,
      flake-compat,
      llama,
      llm-agents,
      agenix,
      oxwm,
      import-tree,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        main-nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            (import-tree ./modules/nixos)
            ./hosts/main-nixos/configuration.nix
            nix-index-database.nixosModules.nix-index
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "bck";
                useGlobalPkgs = true;
                useUserPackages = true;
                users.zexk = {
                  imports = [
                    oxwm.homeManagerModules.default
                    (import-tree ./modules/home-manager)
                    ./hosts/main-nixos/home.nix
                  ];
                };
              };
            }
          ];
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.mkShell {
          name = "nixos-flake";
          packages = with pkgs; [
            # LSP
            nixd

            # Linting
            statix

            # Dead code
            deadnix

            # Formatting (matches formatter output)
            nixfmt

            # Generation diffs
            nvd
          ];

          shellHook = ''
            echo ""
            echo " nixd     — language server (LSP)"
            echo " statix   — lint  (statix check . / statix fix .)"
            echo " deadnix  — dead code  (deadnix .)"
            echo " nixfmt   — format  (nixfmt **/*.nix)"
            echo " nvd      — generation diff  (nvd diff old new)"
            echo ""
          '';
        };
    };
}
