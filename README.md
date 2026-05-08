# NixOS Flakes Configuration

This repository contains my personal NixOS system configuration using flakes.

## Structure

- `modules/` - System and home manager modules
- `hosts/kuwadorian/` - Host-specific configuration for kuwadorian system
- `secrets/` - Encrypted secrets managed with agenix
- `pkgs/` - Custom Nix packages

## Key Features

- Home Manager integration for user environment
- Modular configuration approach
- Secret management via agenix
- Development tools and editors (Zed, Neovim)
- Custom window manager (oxwm)

## Usage

Build the system:
```
nix build .#kuwadorian
```

Run the system:
```
nix run .#kuwadorian
```

Switch to configuration:
```
sudo nixos-rebuild switch --flake .#kuwadorian
```

Update flake lock:
```
nix flake update
```
