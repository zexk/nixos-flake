# OpenCode Agent Instructions

## Repository Overview

This is a NixOS flake configuration with:
- 50+ modules in `modules/` (alacritty, neovim, bluetooth, mpv, etc.)
- Host configuration in `hosts/` (currently `kuwadorian`)
- Secret management via `agenix`
- Agent skills in `modules/_opencode/skills/`

## Key Commands

### Build and Deploy
- Build system: `nix build .#nixosConfigurations.kuwadorian.config.system.build.toplevel`
- Switch to configuration: `sudo nixos-rebuild switch --flake .#kuwadorian`

### Development Workflow
- Format all Nix files: `./format.sh`
- Update flake lock: `nix flake update`
- Check syntax: `nix eval .#kuwadorian`

## Architecture Notes

### Module Structure
- Modules are in `modules/` directory
- Host configuration is in `hosts/kuwadorian/` 
- Home manager modules are in `hosts/kuwadorian/_home.nix`
- NixOS modules are imported via `flake.nix` using `import-tree`

### Flakes and Inputs
- Uses flake-parts for organization
- Multiple inputs including nixpkgs, home-manager, agenix, etc.
- Lock file in `flake.lock` for reproducible builds

### Secret Management
- Secrets handled via `agenix`
- Secrets are stored in `secrets.nix` and encrypted `.age` files
- Requires `nix secret add` for new secrets

## Agent-Specific Guidance

### NixOS Development
- Use `nix build .#nixosConfigurations.kuwadorian.config.system.build.toplevel` to test system builds
- Use `nix eval .#kuwadorian` to check module evaluation
- Changes to modules require rebuilding the system

### Module Editing
- New modules should be added to `modules/`
- Host-specific configurations are in `hosts/kuwadorian/`
- Module files use Nix syntax and follow existing patterns

### Testing and Validation
- Run `./format.sh` after making changes to Nix files
- Verify module evaluation with `nix eval .#kuwadorian`
- Test builds with `nix build .#nixosConfigurations.kuwadorian.config.system.build.toplevel`

## Important Constraints

1. **NixOS Rebuild Required**: Changes to system configuration must be rebuilt using `nixos-rebuild switch`
2. **Secret Handling**: Secrets require proper agenix setup and encrypted files
3. **Module Dependencies**: Modules are imported through flake-parts structure in `flake.nix`
4. **Format Enforcement**: All Nix files must be formatted with `nix fmt` using `format.sh`
