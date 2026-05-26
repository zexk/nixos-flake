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

    umbra = {
      url = "github:zexk/umbra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use own fork until changes get merged
    oxwm.url = "github:zexk/oxwm/master";

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.home-manager.flakeModules.home-manager
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
