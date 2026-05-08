# NixOS Flake Configuration

A NixOS flake for custom system configuration with modules, secrets, and agent skills.

## Features

- **50+ modules** in `modules/` (alacritty, neovim, bluetooth, mpv, etc.)
- **Secret management** via `secrets.nix` and `secret1.age`
- **Agent skills** in `modules/_opencode/skills/` (caveman, find-skills, etc.)
- **Overlays** for custom Nixpkgs modifications (`modules/_overlays/`)
- **Flake.lock** for dependency pinning
- **Format.sh** for code formatting

- **50+ modules** in `modules/` (alacritty, neovim, bluetooth, mpv, etc.)
- **Secret management** via `secrets.nix` and `secret1.age`
- **Agent skills** in `modules/_opencode/skills/` (caveman, find-skills, etc.)
- **Overlays** for custom Nixpkgs modifications (`modules/_overlays/`)
- **Flake.lock** for dependency pinning
- **Format.sh** for code formatting

## Installation

```bash
nix run .#your-project-name
```

## Usage

1. **Customize flake.nix** for global configuration
2. **Edit modules/** to modify individual components
3. **Add secrets** to `secrets.nix` (requires `nix secret add`)
4. **Build system**: `nix build`

5. **Build system**: `nix build`

## Contributing

- Add new modules to `modules/` directory
- Update `flake.nix` for system-wide changes
- Document changes in `README.md`
- Use `format.sh` to maintain code style

- Add new modules to `modules/` directory
- Update `flake.nix` for system-wide changes
- Document changes in `README.md`
- Use `format.sh` to maintain code style

## License

[License type] © [Your name]
