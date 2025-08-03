{ config, pkgs, inputs, ... }:

{
  # Packages ported from your Guix configuration
  home.packages = with pkgs; [
    # Development tools
    cmake
    libtool
    gnumake
    gcc
    gdb
    valgrind
    
    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    
    # Terminal utilities
    xterm
    inputs.ghostty.packages.${pkgs.system}.default # Primary terminal
    
    # System tools
    htop
    btop
    mprocs # Run multiple processes in parallel
    neofetch
    keychain
    openssh
    
    # Media
    mpv # Modern replacement for pipe-viewer
    yt-dlp
    
    # Wayland utilities
    wl-clipboard
    grim # Screenshots
    slurp # Selection tool
    wf-recorder # Screen recording
    
    # GUI applications
    firefox-wayland
    chromium
    google-chrome
    
    # File management
    ranger
    pcmanfm
    
    # Additional tools matching your workflow
    jq
    fzf
    bat
    eza # Better ls
    zoxide # Better cd
    
    # Python (for Doom Emacs and general dev)
    python3
    python3Packages.pip
    python3Packages.virtualenv
    
    # Node.js (for Doom Emacs packages and npm)
    nodejs
    
    # Claude CLI (official Anthropic tool)
    claude-code
    
    
    # Fonts and themes
    papirus-icon-theme
    arc-theme
  ];
}