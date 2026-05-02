{ inputs, self, ... }:
{
  flake.nixosConfigurations.kuwadorian = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = (builtins.attrValues self.nixosModules) ++ [
      inputs.nix-index-database.nixosModules.nix-index
      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          backupFileExtension = "bck";
          useGlobalPkgs = true;
          useUserPackages = true;
          users.zexk = {
            imports = (builtins.attrValues self.homeModules) ++ [
              inputs.oxwm.homeManagerModules.default
              ./_home.nix
            ];
          };
        };
      }
    ];
  };

  flake.nixosModules.kuwadorian =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [ ./_hardware-configuration.nix ];

      # Bootloader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "kuwadorian";

      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernel.sysctl."kernel.split_lock_mitigate" = 0;

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "gator" ];
      };

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.nixos-cuda.org"
          "https://cache.numtide.com"
          "https://cuda-maintainers.cachix.org"
          "https://llama-cpp.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
          "llama-cpp.cachix.org-1:H75X+w83wUKTIPSO1KWy9ADUrzThyGs8P5tmAbkWhQc="
        ];
      };

      allowedUnfree = [
        "reaper"
        "renoise"
        "davinci-resolve"
        "blender" # CUDA
        "duckstation"
        "cuda_cudart"
        "cuda_cuobjdump"
        "cuda_cccl"
        "cuda_nvdisasm"
        "cuda_nvcc"
        "cuda_profiler_api"
        "cuda-merged"
        "cudatoolkit"
        "libnpp"
        "libcublas"
        "libcusolver"
        "libcufft"
        "libcurand"
        "libcufile"
        "libcusparse"
        "libcusparse_lt"
        "libnvjitlink"
        "cudnn"
        "cuda_nvrtc"
        "cuda_cupti"
        "cuda_nvml_dev"
        "cuda_nvtx"
        "open-webui"
      ];

      programs.nix-index-database.comma.enable = true;

      hardware.keyboard.qmk.enable = true;
      hardware.enableRedistributableFirmware = true;

      programs.bash.enable = true;
      users.defaultUserShell = pkgs.bash;

      virtualisation.docker.enable = true;

      users.users.zexk = {
        isNormalUser = true;
        description = "zexk";
        extraGroups = [
          "docker"
          "networkmanager"
          "wheel"
          "gamemode"
        ];
        packages = [ ];
      };

      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      programs.gamemode.enable = true;

      environment.systemPackages = [
        pkgs.vim
        pkgs.wget
        pkgs.ntfs3g
        inputs.agenix.packages."x86_64-linux".default
      ];

      programs.dconf.enable = true;

      security.rtkit.enable = true;
      security.polkit.enable = true;

      networking.firewall.allowedTCPPorts = [ 22 ];

      system.stateVersion = "24.05";
    };
}
