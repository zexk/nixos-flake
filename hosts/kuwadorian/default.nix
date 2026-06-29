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
              inputs.agenix.homeManagerModules.default
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
        "duckstation"
        "claude-code"
      ];

      programs.nix-index-database.comma.enable = true;

      hardware.keyboard.qmk.enable = true;
      hardware.enableRedistributableFirmware = true;

      programs.bash.enable = true;
      programs.fish.enable = true;
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
        shell = pkgs.fish;
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
          # fonts
          self.packages.${pkgs.stdenv.hostPlatform.system}.pxplus-ibm-vga8-2x
          inputs.tessera-mono.packages.${pkgs.stdenv.hostPlatform.system}.otb-1x
          inputs.tessera-mono.packages.${pkgs.stdenv.hostPlatform.system}.otb-2x

          yacreader

          # browsers
          ladybird

          # messaging
          telegram-desktop

          # audio
          pavucontrol
          paprefs
          wireplumber
          mpc

          # productivity
          calcurse
          qalculate-gtk
          libreoffice

          # creative
          drawy
          reaper
          davinci-resolve

          # networking
          transmission_4-gtk
          proton-vpn

          # virtualization
          qemu
          kvmtool

          # wine
          wineWow64Packages.stable
          winetricks

          # gaming - launchers
          lumafly
          steamtinkerlaunch

          # gaming - emulators
          pcsx2
          ppsspp
          shadps4-qtlauncher
          dolphin-emu

          # x11
          screenkey
          scrcpy
          xsel
          xclip
          xcolor
          maim
          libnotify

          # files
          pcmanfm
          unzip
          p7zip
          ouch

          # cli
          cowsay
          file
          which
          tree
          gnused
          gawk
          gnupg
          lsof
          tokei
          tmux-sessionizer

          # monitoring
          iotop
          iftop
        ];
      };

      home.stateVersion = "23.11";
      programs.home-manager.enable = true;
    };
}
