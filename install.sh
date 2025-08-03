#!/usr/bin/env bash
set -e

echo "NixOS + Hyprland Development Environment Installer"
echo "=================================================="

# Check if we're on NixOS
if [ ! -f /etc/nixos/configuration.nix ]; then
    echo "Error: This script must be run on NixOS"
    exit 1
fi

# Get user information
read -p "Enter your username: " USERNAME
read -p "Enter your hostname (default: lsp-desktop): " HOSTNAME
HOSTNAME=${HOSTNAME:-lsp-desktop}

# Enable flakes if not already enabled
echo "Checking if flakes are enabled..."
if ! nix flake --version &> /dev/null; then
    echo "Enabling flakes..."
    sudo mkdir -p /etc/nix
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    sudo systemctl restart nix-daemon
fi

# Update configuration files
echo "Updating configuration files..."
find . -type f -name "*.nix" -o -name "*.md" | while read -r file; do
    sed -i "s/lsp/$USERNAME/g" "$file"
    sed -i "s/dev-machine/$HOSTNAME/g" "$file"
done

# Generate hardware configuration
echo "Generating hardware configuration..."
sudo nixos-generate-config --show-hardware-config > "hosts/$HOSTNAME/hardware-configuration.nix"

# Create symlink for Doom config
echo "Setting up Doom Emacs configuration..."
mkdir -p "$HOME/.doom.d.backup" 2>/dev/null || true
if [ -d "$HOME/.doom.d" ]; then
    echo "Backing up existing Doom config to ~/.doom.d.backup"
    cp -r "$HOME/.doom.d"/* "$HOME/.doom.d.backup/" 2>/dev/null || true
fi

# Copy Home Assistant config if present
if [ -d "../homeassistant_cfg" ]; then
    echo "Copying Home Assistant configuration..."
    cp -r ../homeassistant_cfg .
fi

# Build the system
echo "Building NixOS configuration..."
sudo nixos-rebuild switch --flake ".#$HOSTNAME"

echo ""
echo "Installation complete!"
echo "====================="
echo ""
echo "Next steps:"
echo "1. Reboot your system"
echo "2. Log in and select Hyprland from your display manager"
echo "3. Doom Emacs will install on first run"
echo "4. Customize monitor settings in home/hyprland.nix"
echo ""
echo "To update your system later:"
echo "  cd $(pwd)"
echo "  nix flake update"
echo "  sudo nixos-rebuild switch --flake .#$HOSTNAME"
echo ""
echo "Your configuration is also available at:"
echo "  https://github.com/lane-s/nixos-config"