{ inputs, self, ... }:
{
  flake = {
    nixosConfigurations.kuwadorian = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = (builtins.attrValues self.nixosModules) ++ [
        inputs.nix-index-database.nixosModules.nix-index
        inputs.agenix.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "backup";
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

    nixosModules.kuwadorian =
      {
        pkgs,
        inputs,
        ...
      }:
      {
        imports = [ ./hardware-configuration.nix ];

        boot = {
          loader.systemd-boot.enable = true;
          loader.efi.canTouchEfiVariables = true;
          kernelPackages = pkgs.linuxPackages_latest;
          kernel.sysctl."kernel.split_lock_mitigate" = 0;
        };

        networking.hostName = "kuwadorian";

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

        programs = {
          nix-index-database.comma.enable = true;
          bash.enable = true;
          fish.enable = true;
          dconf.enable = true;
          gamemode.enable = true;

          appimage = {
            enable = true;
            binfmt = true;
          };
        };

        hardware.keyboard.qmk.enable = true;
        hardware.enableRedistributableFirmware = true;

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

        environment.systemPackages = [
          pkgs.vim
          pkgs.wget
          pkgs.ntfs3g
          inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

        security.rtkit.enable = true;
        security.polkit.enable = true;

        networking.firewall.allowedTCPPorts = [ 22 ];

        system.stateVersion = "24.05";
      };

    homeModules.kuwadorian =
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
            me3
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
  };
}
