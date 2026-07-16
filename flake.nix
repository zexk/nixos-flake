{
  description = "zexk's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    llm-agents.url = "github:numtide/llm-agents.nix";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    agenix.url = "github:ryantm/agenix";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbra = {
      url = "github:zexk/umbra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wstudio = {
      url = "github:zexk/wstudio/prototype";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zctl.url = "github:zexk/zctl";

    tessera-mono = {
      url = "github:zexk/tessera-mono";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # use own fork until changes get merged
    oxwm.url = "github:zexk/oxwm/master";

    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.home-manager.flakeModules.home-manager
        inputs.pre-commit-hooks.flakeModule
        (inputs.import-tree ./modules)
        (inputs.import-tree.filterNot (
          p: inputs.nixpkgs.lib.hasSuffix "hardware-configuration.nix" p
        ) ./hosts)
      ];
      perSystem =
        { pkgs, ... }:
        {
          packages.pxplus-ibm-vga8-2x = pkgs.callPackage ./pkgs/pxplus-ibm-vga8-2x { };
          packages.dmenu = pkgs.callPackage ./pkgs/dmenu { };
        };
    };
}
