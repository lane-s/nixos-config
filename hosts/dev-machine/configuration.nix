{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/hyprland.nix
    # ../../modules/home-assistant.nix  # Uncomment to enable Home Assistant
  ];

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "dev-machine"; # Replace with your hostname
    networkmanager.enable = true;
  };

  # Time zone and localization
  time.timeZone = "America/New_York"; # Adjust to your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  # User configuration
  users.users.youruser = { # Replace with your username
    isNormalUser = true;
    description = "Your Name"; # Replace with your name
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.bash;
  };

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # This value determines the NixOS release
  system.stateVersion = "24.05";
}