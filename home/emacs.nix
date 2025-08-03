{ config, pkgs, inputs, ... }:

{
  # Emacs configuration
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30; # Regular build instead of PGTK
    extraPackages = epkgs: with epkgs; [
      vterm
      pdf-tools
      treemacs
    ];
  };

  # Link Doom config from this repo
  home.file.".doom.d" = {
    source = ../. + "/.doom.d";
    recursive = true;
  };

  # Doom Emacs dependencies
  home.packages = with pkgs; [
    # Required dependencies
    git
    (ripgrep.override { withPCRE2 = true; })
    fd
    
    # Optional dependencies
    imagemagick
    pinentry-emacs
    zstd
    
    # Module dependencies
    ## :tools editorconfig
    editorconfig-core-c
    
    ## :tools lookup & :lang org +roam
    sqlite
    
    ## :lang cc
    ccls
    
    ## :lang latex
    texlive.combined.scheme-medium
    
    ## :lang python
    python3
    python3Packages.pip
    python3Packages.black
    python3Packages.pyflakes
    python3Packages.isort
    python3Packages.pytest
    
    ## :lang rust
    rustc
    cargo
    rust-analyzer
    
    ## :lang sh
    shellcheck
    
    ## :term vterm
    cmake
    libtool
    libvterm
  ];

  # Environment variables for Emacs
  home.sessionVariables = {
    # Emacs daemon socket
    EMACS_SOCKET_NAME = "server";
    
    # Ensure Emacs uses native compilation cache in user directory
    NATIVE_FULL_AOT = "1";
    
    # Help Emacs work better with Wayland
    GDK_BACKEND = "wayland,x11";
  };

  # Systemd service for Emacs daemon
  services.emacs = {
    enable = true;
    defaultEditor = true;
    client = {
      enable = true;
      arguments = [ "-c" "-a" "emacs" ];
    };
  };

  # Script to install Doom Emacs on first run
  home.activation.installDoom = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.emacs.d" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs $HOME/.emacs.d
      $DRY_RUN_CMD PATH="${pkgs.emacs}/bin:${pkgs.git}/bin:${pkgs.ripgrep}/bin:$PATH" $HOME/.emacs.d/bin/doom install --no-env --no-fonts
    fi
  '';
}