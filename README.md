# 🖥️ NixOS Flake Configuration - zexk's Setup

This repository contains a highly customized, production-ready NixOS configuration managed via Nix Flakes and Home Manager. It establishes a powerful, aesthetically pleasing, and modular desktop environment centered around the Awesome Window Manager.

## 🚀 Overview

This setup is designed for a developer/power user who values efficiency, customization, and reproducibility. All configurations are managed declaratively through Nix, ensuring that the entire system state (Host and User) can be rebuilt identically at any time.

The primary focus is on delivering a sleek, dark-themed, tiling experience powered by AwesomeWM.

## ✨ Key Features

### ⚙️ System & Infrastructure
*   **Nix Flakes:** Full adoption of Flakes for reproducible dependency management across the host and user layers.
*   **Modular Design:** Clear separation between system-level configurations (`nixos/`) and user-level configurations (`home-manager/`).
*   **Robustness:** Includes explicit handling for system errors, kernel tuning (`kernel.split_lock_mitigate`), and explicit definition of allowed unfree packages (including CUDA libraries).
*   **Networking & Services:** Pre-configured for PostgreSQL, NetworkManager, and SSH access.

### 🎨 Desktop Experience (AwesomeWM)
*   **Tiling Window Manager:** Powered by AwesomeWM, featuring responsive layouts (Tile, Floating, Spiral, etc.).
*   **Custom Theming:** A comprehensive `theme.lua` defines a professional, dark color palette and scales perfectly using DPI awareness.
*   **Feature-Rich Keybindings:** `rc.lua` provides deep keyboard control over:
    *   Tag Navigation (view, toggle, move).
    *   Client Manipulation (fullscreen, maximize, minimize, swap).
    *   Workflow Utilities (terminal spawn, Awesome reload, help).
*   **Integrated Launcher:** Uses `dmenu` as the primary application launcher, accessible via `Mod+p`.

### 📦 Package Ecosystem (Home Manager)
The user environment is heavily provisioned with high-quality applications, including:
*   **Development Tools:** `ripgrep`, `fzf`, `zoxide`, `neovim` (via NixOS module), `qalculate-gtk`.
*   **Graphics & Media:** `Blender`, `Davinci Resolve`, `MPV`, `Obs`, `Picom` (compositor).
*   **Emulation:** Full support for retro gaming (`RetroArch`, `PPSSPP`, `RPCS3`, `ShadPS4`).
*   **Productivity:** `Zsh`/`Starship` shell, `Timewatch` (`tokei`), `Transmission-GTK`.

## 🗂️ Repository Structure

```
.
├── flake.nix               # The root manifest defining inputs and outputs.
├── hosts/
│   └── kuwadorian/         # NixOS Host configuration directory.
│       ├── configuration.nix  # Primary system settings (packages, services, etc.).
│       └── hardware-configuration.nix # Hardware specifics.
├── home-manager/           # User environment configuration directory.
│   ├── home.nix            # Main user definition, imports all sub-configs.
│   ├── awesome/            # AwesomeWM specific settings.
│   │   ├── home.nix        # Declares AWESOMEWM module & links files.
│   │   ├── rc.lua          # Runtime logic: Keybindings, Rules, Widgets.
│   │   └── theme.lua       # Visual definitions: Colors, Fonts, DPI scaling.
├── nixos/                  # Contains modules for specific services (e.g., nvidia, steam).
├── secrets/                # Sensitive configuration files (e.g., secret1.age).
└── ... (other modules)
```

## 🛠️ Getting Started

### Prerequisites
Ensure you have Nix and Home Manager installed on your system.

### Installation Steps
1.  **Clone the Repository:**
    ```bash
    git clone <repository-url>
    cd nixos-flake
    ```

2.  **Install System Configuration (Host):**
    Apply the configuration defined in `hosts/kuwadorian/configuration.nix`.
    ```bash
    nixos-rebuild switch --flake .#kuwadorian
    ```
    *This command builds and activates the system configuration for the `kuwadorian` host.*

3.  **Install User Configuration (Home Manager):**
    Apply the configuration defined in `home-manager/home.nix`.
    ```bash
    home-manager switch --flake .#kuwadorian
    ```
    *This command builds and activates the user environment for the `zexk` user.*

4.  **Verify:**
    After installation, log in, and you should find your custom desktop environment running.

### 🔑 Key Commands
*   **System Upgrade:** `nixos-rebuild switch --flake .#kuwadorian`
*   **User Upgrade:** `home-manager switch --flake .#kuwadorian`
*   **Check Status:** `home-manager status --flake .#kuwadorian`
*   **Rebuild Everything:** (If you change both host and user configs) Run both commands above.

## 🧑‍💻 Development Notes
*   **Theming:** Adjust colors/fonts in `home-manager/awesome/theme.lua`.
*   **Keybindings:** Modify or add bindings in `home-manager/awesome/rc.lua` within the `globalkeys` table.
*   **Packages:** Add new software to the `packages` list in `home-manager/home.nix`.
*   **Modules:** Add new services or configurations to `nixos/` and update `hosts/kuwadorian/configuration.nix` to import them.
