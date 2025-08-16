#!/bin/bash
set -euo pipefail

# macOS-specific installation script
# Installs Nix, home-manager, and sets up dotfiles

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "🍎 Setting up macOS configuration..."

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

# Apply home-manager configuration
if [[ -f "$REPO_DIR/home/home.nix" ]]; then
    echo "🔧 Applying home-manager configuration..."
    home-manager switch --flake "$REPO_DIR"
else
    echo "⚠️  No home-manager configuration found, skipping..."
fi

# Link Doom Emacs config
if [[ -d "$REPO_DIR/.doom.d" ]]; then
    echo "🎯 Linking Doom Emacs configuration..."
    rm -rf ~/.doom.d
    ln -sf "$REPO_DIR/.doom.d" ~/.doom.d
fi

# Install and setup Doom Emacs if not present
if [[ ! -d ~/.emacs.d ]]; then
    echo "⚡ Installing Doom Emacs..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
else
    echo "✅ Doom Emacs already installed"
fi

echo "✅ macOS setup complete!"
echo "   Consider installing additional tools manually:"
echo "   - Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
echo "   - Development tools: brew install git docker"