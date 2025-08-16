#!/bin/bash
set -euo pipefail

# NixOS-specific installation script
# Handles both fresh installs and existing NixOS systems

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
REPO_URL="https://github.com/lspangler/init-env.git"

echo "🐧 Setting up NixOS configuration..."

# Backup existing /etc/nixos if it exists
if [[ -e /etc/nixos ]]; then
    echo "📁 Backing up existing /etc/nixos..."
    sudo mkdir -p /etc/nixos.backup.$(date +%Y%m%d-%H%M%S)
    sudo cp -r /etc/nixos/* /etc/nixos.backup.$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
fi

# Clone or update the repo directly in /etc/nixos
if [[ -d /etc/nixos/.git ]]; then
    echo "📦 Updating existing /etc/nixos repository..."
    cd /etc/nixos
    sudo git pull origin main
else
    echo "📦 Cloning repository to /etc/nixos..."
    sudo rm -rf /etc/nixos
    sudo git clone "$REPO_URL" /etc/nixos
fi

# Ensure we're using flakes
if ! command -v nix-env &> /dev/null || ! nix-env --version | grep -q "2\."; then
    echo "⚠️  Warning: Nix might not support flakes. Consider updating Nix."
fi

# Test the configuration
echo "🧪 Testing NixOS configuration..."
sudo nixos-rebuild dry-build --flake /etc/nixos

# Ask user if they want to apply the configuration
echo ""
read -p "🤔 Apply configuration now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Applying NixOS configuration..."
    sudo nixos-rebuild switch --flake /etc/nixos
    echo "✅ NixOS configuration applied successfully!"
    echo "   You may need to log out and back in for all changes to take effect."
else
    echo "⏭️  Configuration ready. Run 'sudo nixos-rebuild switch --flake /etc/nixos' when ready."
fi

echo "✅ NixOS setup complete!"