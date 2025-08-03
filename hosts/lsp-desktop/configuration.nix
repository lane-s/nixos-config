{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/hyprland.nix
    # ../../modules/home-assistant.nix  # Uncomment to enable Home Assistant
  ];

  # Boot configuration - BIOS/GRUB
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sdb"; # Install GRUB to the MBR
    };
  };

  # Networking (NetworkManager configured in base.nix for Atheros support)
  networking.hostName = "lsp-desktop";

  # Time zone and localization
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # User configuration
  users.users.lsp = { # Replace with your username
    isNormalUser = true;
    description = "Your Name"; # Replace with your name
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.bash;
  };

  # Enable sound (sound.enable is deprecated, pipewire handles it)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # OpenSSH
  services.openssh.enable = true;

  # System packages (minimal, most go in home-manager)
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # Allow unfree packages (needed for NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release
  system.stateVersion = "24.05";
}