#!/bin/bash
set -euo pipefail

# Universal bootstrap script for lspangler's development environment
# Works on: NixOS, macOS, and other Linux distributions

REPO_URL="https://github.com/lspangler/init-env.git"
INSTALL_DIR="$HOME/.init-env"

echo "🚀 Bootstrapping development environment..."

# Detect operating system
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    OS=$ID
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo "❌ Unsupported operating system"
    exit 1
fi

echo "📋 Detected OS: $OS"

# Clone or update repository
if [[ -d "$INSTALL_DIR" ]]; then
    echo "📦 Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull origin main
else
    echo "📦 Cloning repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Run OS-specific installation
case $OS in
    "nixos")
        echo "🐧 Setting up NixOS configuration..."
        ./install/nixos.sh
        ;;
    "macos")
        echo "🍎 Setting up macOS configuration..."
        ./install/macos.sh
        ;;
    "ubuntu"|"debian"|"arch"|"fedora")
        echo "🐧 Setting up Linux configuration..."
        ./install/linux.sh
        ;;
    *)
        echo "⚠️  Unsupported OS: $OS"
        echo "   Attempting generic Linux setup..."
        ./install/linux.sh
        ;;
esac

echo "✅ Bootstrap complete! Your development environment is ready."