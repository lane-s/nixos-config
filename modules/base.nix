{ config, pkgs, ... }:

{
  # Basic system configuration that ports your Guix setup
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # System-wide packages (minimal, most should go in home-manager)
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
    ripgrep
    fd
    tree
    file
    which
    gnused
    gnutar
    gzip
    unzip
    xz
  ];

  # Enable documentation
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  # Shell configuration
  programs.bash = {
    enableCompletion = true;
    shellAliases = {
      ll = "ls -lha";
      ls = "ls -p --color=auto";
      grep = "grep --color=auto";
    };
  };

  # Security
  security.sudo.wheelNeedsPassword = true;

  # Locale settings (matching your Guix config)
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Remap Caps Lock to Escape system-wide
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  # Hardware support for i5-4690K and Atheros AR93xx
  boot = {
    # Ensure Atheros wireless drivers are loaded
    kernelModules = [ "ath9k" ];
    
    # Microcode updates for Intel Haswell CPU
    kernelParams = [ "intel_pstate=enable" ];
  };

  # Firmware for Atheros wireless
  hardware.enableRedistributableFirmware = true;
  
  # Network configuration for Atheros wireless
  networking.wireless.enable = false; # We use NetworkManager instead
  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant"; # Better for Atheros cards
  };
}