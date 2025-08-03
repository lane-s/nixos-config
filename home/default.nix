{ config, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./hyprland.nix
    ./emacs.nix
  ];

  # Home Manager configuration
  home = {
    username = "youruser"; # Replace with your username
    homeDirectory = "/home/youruser"; # Replace with your home directory
    stateVersion = "24.05";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name"; # Replace
    userEmail = "your.email@example.com"; # Replace
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # SSH
  programs.ssh = {
    enable = true;
    startAgent = true;
  };

  # XDG configuration
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };
}