# Custom NixOS Multi-Config Installer

This creates a custom NixOS installer ISO (based on the official minimal installer) that lets you choose between multiple NixOS configurations during installation.

## What is this?

This builds a modified NixOS minimal installer ISO that includes:
- The standard NixOS installer (networking, partitioning, etc.)
- A custom menu system for selecting configurations
- Git and other tools pre-installed
- An automated installation script

## Features

- **Interactive menu** to select configuration
- **Automatic partitioning** and formatting  
- **Network setup** built-in
- **Multiple configs** on one USB
- **Clones from Git** for latest configs

## Building the ISO

```bash
cd installer
./build-iso.sh
```

## Using the Installer

1. Boot from USB
2. Run `nixos-install-custom`
3. Select your configuration:
   - Desktop (Hyprland + NVIDIA)
   - Laptop (Power management)
   - Server (Headless)
   - Custom (Any git repo)
4. Select disk to install on
5. Enter username
6. Wait for installation

## Adding More Configurations

Edit `installer-config.nix` and add new options to the menu:

```nix
"my-config - Description" \
```

Then add the case:
```bash
"my-config"*)
  CONFIG_NAME="my-config"
  CONFIG_REPO="https://github.com/user/repo"
  ;;
```

## Advanced: Embed Configs in ISO

Instead of cloning from git, you can embed configs directly:

```nix
environment.etc."nixos-configs/desktop" = {
  source = ../hosts/lsp-desktop;
  recursive = true;
};
```

This includes the config files in the ISO itself!