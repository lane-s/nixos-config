#!/bin/bash
set -euo pipefail

# Generic Linux installation script
# Works on Ubuntu, Debian, Arch, Fedora, etc.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "🐧 Setting up Linux configuration..."

# Detect package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    PKG_INSTALL="sudo apt update && sudo apt install -y"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    PKG_INSTALL="sudo pacman -S --noconfirm"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    PKG_INSTALL="sudo dnf install -y"
elif command -v zypper &> /dev/null; then
    PKG_MANAGER="zypper"
    PKG_INSTALL="sudo zypper install -y"
else
    echo "⚠️  Unknown package manager. Manual installation required."
    PKG_MANAGER="unknown"
fi

echo "📋 Detected package manager: $PKG_MANAGER"

# Install basic dependencies
if [[ "$PKG_MANAGER" != "unknown" ]]; then
    echo "📦 Installing basic dependencies..."
    $PKG_INSTALL curl git xz-utils
fi

# Install Nix if not present
if ! command -v nix &> /dev/null; then
    echo "📦 Installing Nix package manager..."
    curl -L https://nixos.org/nix/install | sh -s -- --daemon
    
    # Source nix profile
    if [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
        source ~/.nix-profile/etc/profile.d/nix.sh
    fi
else
    echo "✅ Nix already installed"
fi

# Enable flakes
echo "🔧 Enabling Nix flakes..."
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Install home-manager
if ! command -v home-manager &> /dev/null; then
    echo "🏠 Installing home-manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
else
    echo "✅ home-manager already installed"
fi

# Link dotfiles
echo "🔗 Linking dotfiles..."
if [[ -d "$REPO_DIR/.doom.d" ]]; then
    rm -rf ~/.doom.d
    ln -sf "$REPO_DIR/.doom.d" ~/.doom.d
fi

# Apply home-manager configuration (if available)
if [[ -f "$REPO_DIR/nixos/home/home.nix" ]]; then
    echo "🔧 Applying home-manager configuration..."
    # Note: This might need adaptation for non-NixOS systems
    home-manager switch --flake "$REPO_DIR/nixos" || echo "⚠️  home-manager configuration may need adjustment for this system"
fi

echo "✅ Linux setup complete!"
echo "   Note: Some features (like Hyprland) may require additional setup on non-NixOS systems."