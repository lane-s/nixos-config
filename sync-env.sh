#!/usr/bin/env bash
# Sync script for NixOS configuration

INIT_DIR=$(pwd)
CONFIG_DIR="$HOME/.init-env/nixos-config"

# Ensure we're in the right directory
if [ ! -f "$CONFIG_DIR/flake.nix" ]; then
    echo "Error: Not in nixos-config directory"
    echo "Please run from $CONFIG_DIR"
    exit 1
fi

cd "$CONFIG_DIR"

# Update flake inputs
echo "Updating flake inputs..."
nix flake update

# Check for changes
if [[ -n $(git status --porcelain) ]]; then
    echo "Local changes detected. Opening git..."
    # Try to use emacsclient if available, otherwise fall back to git
    if command -v emacsclient &> /dev/null; then
        emacsclient --eval "(magit-status \"$CONFIG_DIR\")"
    else
        git status
        echo ""
        echo "Please commit your changes:"
        echo "  git add -A"
        echo "  git commit -m 'Update configuration'"
        echo "  git push"
    fi
else
    echo "No local changes detected."
fi

# Offer to rebuild
read -p "Rebuild system now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    HOSTNAME=$(hostname)
    sudo nixos-rebuild switch --flake ".#$HOSTNAME"
fi

cd "$INIT_DIR"