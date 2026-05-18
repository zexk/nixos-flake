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
          backupFileExtension = "b";
          useGlobalPkgs = true;
          useUserPackages = true;
          users.zexk = {
            imports = (builtins.attrValues self.homeModules) ++ [
              inputs.oxwm.homeManagerModules.default
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
      imports = [ ./hardware-configuration.nix ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "kuwadorian";

      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernel.sysctl."kernel.split_lock_mitigate" = 0;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.numtide.com"
          "https://llama-cpp.cachix.org"
        ];
        trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
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

  flake.homeModules.kuwadorian =
    { pkgs, ... }:
    {
      home = {
        username = "zexk";
        homeDirectory = "/home/zexk";

        packages = with pkgs; [
          dmenu
          pixel-code
          kirsch
          self.packages.${pkgs.stdenv.hostPlatform.system}.pxplus-ibm-vga8-2x

          floorp-bin

          drawy

          wineWow64Packages.stable
          winetricks

          qalculate-gtk

          ladybird

          xdg-desktop-portal

          pavucontrol

          screenkey
          scrcpy

          mpc
          feh

          paprefs
          wireplumber

          unzip
          p7zip

          cowsay
          file
          which
          tree
          gnused
          gawk
          gnupg
          lsof

          xsel
          xclip
          xcolor
          maim

          transmission_4-gtk

          pcmanfm
          tokei

          ayugram-desktop
          vesktop

          calcurse

          btop
          iotop
          iftop
          libnotify

          qemu
          virt-manager
          kvmtool

          lumafly
          prismlauncher
          steamtinkerlaunch

          pcsx2
          ppsspp
          shadps4
          dolphin-emu

          libreoffice
          reaper
          reaper-sws-extension
          reaper-reapack-extension
          lmms
          lsp-plugins
          davinci-resolve

          proton-vpn

          tmux-sessionizer
        ];
      };

      home.stateVersion = "23.11";
      programs.home-manager.enable = true;
    };
}
