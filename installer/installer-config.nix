{ config, pkgs, lib, ... }:

{
  # Base installer configuration
  imports = [
    # Include the default installer
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
  ];

  # Enable flakes in installer
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Include git and other tools
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    ranger  # File browser
    gum     # Pretty CLI menus
  ];

  # Add your configurations to the ISO
  environment.etc = {
    "nixos-configs/desktop/.keep".text = "";
    "nixos-configs/laptop/.keep".text = "";
    "nixos-configs/server/.keep".text = "";
  };

  # Custom installer script
  environment.etc."nixos-installer-custom" = {
    mode = "0755";
    text = ''
      #!/usr/bin/env bash
      set -e

      echo "======================================"
      echo "   NixOS Multi-Config Installer"
      echo "======================================"
      echo

      # Network setup
      echo "Setting up network connection..."
      if command -v nmtui &> /dev/null; then
        nmtui-connect
      else
        echo "Please connect to network manually"
        echo "WiFi: nmcli device wifi connect SSID password PASSWORD"
      fi

      # Select configuration
      echo
      echo "Available configurations:"
      CONFIGS=$(gum choose \
        "lsp-desktop - Desktop with Hyprland, NVIDIA support" \
        "lsp-laptop - Laptop with power management" \
        "lsp-server - Headless server" \
        "custom - Clone from GitHub URL")

      case "$CONFIGS" in
        "lsp-desktop"*)
          CONFIG_NAME="lsp-desktop"
          CONFIG_REPO="https://github.com/lspangler/init-env"
          ;;
        "lsp-laptop"*)
          CONFIG_NAME="lsp-laptop"
          CONFIG_REPO="https://github.com/lspangler/init-env"
          ;;
        "lsp-server"*)
          CONFIG_NAME="lsp-server"
          CONFIG_REPO="https://github.com/lspangler/init-env"
          ;;
        "custom"*)
          CONFIG_REPO=$(gum input --placeholder "Enter git repository URL")
          CONFIG_NAME=$(gum input --placeholder "Enter configuration name (e.g., desktop)")
          ;;
      esac

      # Disk selection
      echo
      echo "Available disks:"
      lsblk -d -o NAME,SIZE,MODEL
      echo
      DISK=$(gum input --placeholder "Enter disk device (e.g., sda, nvme0n1)")
      DISK="/dev/$DISK"

      # Confirmation
      echo
      gum confirm "This will ERASE $DISK and install NixOS with $CONFIG_NAME. Continue?" || exit 1

      # Partitioning
      echo "Partitioning $DISK..."
      parted $DISK -- mklabel gpt
      parted $DISK -- mkpart ESP fat32 1MB 512MB
      parted $DISK -- set 1 esp on
      parted $DISK -- mkpart primary 512MB 100%

      # Format
      mkfs.fat -F32 "$${DISK}1" || mkfs.fat -F32 "$${DISK}p1"
      mkfs.ext4 "$${DISK}2" || mkfs.ext4 "$${DISK}p2"

      # Mount
      mount "$${DISK}2" /mnt || mount "$${DISK}p2" /mnt
      mkdir -p /mnt/boot
      mount "$${DISK}1" /mnt/boot || mount "$${DISK}p1" /mnt/boot

      # Clone configuration
      echo "Cloning configuration..."
      git clone $CONFIG_REPO /mnt/etc/nixos

      # Generate hardware config
      nixos-generate-config --root /mnt
      cp /mnt/etc/nixos/hardware-configuration.nix "/mnt/etc/nixos/hosts/$CONFIG_NAME/"

      # Get username
      USERNAME=$(gum input --placeholder "Enter your username" --value "lsp")
      
      # Update username in configs
      find /mnt/etc/nixos -name "*.nix" -exec sed -i "s/lsp/$USERNAME/g" {} \;

      # Install
      echo "Installing NixOS..."
      nixos-install --flake "/mnt/etc/nixos#$CONFIG_NAME"

      echo
      echo "Installation complete! Remove USB and reboot."
    '';
  };

  # Add to system packages
  environment.systemPackages = with pkgs; [
    (writeScriptBin "nixos-install-custom" ''
      #!${pkgs.bash}/bin/bash
      exec /etc/nixos-installer-custom
    '')
  ];

  # Customize the installer greeting
  services.getty.helpLine = lib.mkForce ''
    
    ═══════════════════════════════════════════════════════
    Welcome to NixOS Multi-Config Installer
    
    Type 'nixos-install-custom' to begin installation
    ═══════════════════════════════════════════════════════
  '';
}