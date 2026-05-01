{ pkgs, ... }:
{
  home = {
    username = "zexk";
    homeDirectory = "/home/zexk";

    packages = with pkgs; [
			dmenu
      pixel-code
      kirsch
      nerd-fonts.iosevka-term

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

      limo
      lumafly
      lutris
      prismlauncher
      steamtinkerlaunch

      pcsx2
      ppsspp
      #rpcs3
      shadps4
      dolphin-emu

      libreoffice
      # blender
      reaper
      reaper-sws-extension
      reaper-reapack-extension
      lmms
      lsp-plugins
      davinci-resolve

      proton-vpn

      tmux-sessionizer

      mcp-nixos
    ];
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
