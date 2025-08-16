#!/usr/bin/env bash
# Build custom NixOS installer ISO

set -e

echo "Building custom NixOS installer ISO..."
echo "This will take a while and requires significant disk space."

# Build the ISO
nix build .#installer-iso

# The ISO will be in result/iso/
ISO_PATH=$(find result/iso -name "*.iso" | head -1)

if [ -f "$ISO_PATH" ]; then
    echo "ISO built successfully: $ISO_PATH"
    echo
    echo "To write to USB:"
    echo "  sudo dd if=$ISO_PATH of=/dev/sdX bs=4M status=progress conv=fsync"
else
    echo "ISO build failed!"
    exit 1
fi