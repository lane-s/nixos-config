{ config, pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./hyprland.nix
    ./emacs.nix
    ./ghostty.nix
  ];

  # Home Manager configuration
  home = {
    username = "lsp"; # Replace with your username
    homeDirectory = "/home/lsp"; # Replace with your home directory
    stateVersion = "24.05";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Git configuration - MUST be before activation scripts that use git
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
  };
  
  services.ssh-agent.enable = true;

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
  
  # Create project directory on activation
  home.activation = {
    ensureProjectDir = config.lib.dag.entryAfter ["writeBoundary"] ''
      # Create project directory if it doesn't exist
      $DRY_RUN_CMD mkdir -p ~/src/catch.ideas
    '';
  };
}