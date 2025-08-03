{ config, pkgs, ... }:

{
  # Bash configuration (porting your .bashrc)
  programs.bash = {
    enable = true;
    
    shellAliases = {
      # From your config
      grep = "grep --color=auto";
      ls = "ls -p --color=auto";
      ll = "ls -lha";
      
      # NixOS specific
      nixos-rebuild = "sudo nixos-rebuild switch --flake .#";
      nix-update = "nix flake update";
      
      # Sync command for this setup
      sync-env = "~/.init-env/nixos-config/sync-env.sh";
    };
    
    initExtra = ''
      # Export 'SHELL' to child processes
      export SHELL
      
      # Adjust the prompt depending on whether we're in 'nix develop'
      if [ -n "$IN_NIX_SHELL" ]; then
          export PS1='\u@\h \w [nix-shell]\$ '
      else
          export PS1='\u@\h \w\$ '
      fi
      
      # Add doom executable to path
      export PATH="$HOME/.emacs.d/bin:$PATH"
      
      # SSH agent (using keychain like in your config)
      eval $(keychain --eval --quiet id_rsa id_ed25519)
      
      # Set default editor
      export EDITOR="emacsclient -t"
      export VISUAL="emacsclient -c"
      
      # Wayland-specific environment variables
      export MOZ_ENABLE_WAYLAND=1
      export NIXOS_OZONE_WL=1
      
      # Better defaults
      export LESS="-R"
      export GREP_COLOR="1;33"
    '';
    
    profileExtra = ''
      # Login shell configuration
      if [ -f "~/.profile" ]; then source ~/.profile; fi
    '';
  };
  
  # Readline configuration
  programs.readline = {
    enable = true;
    extraConfig = ''
      set show-all-if-ambiguous on
      set completion-ignore-case on
      set colored-stats on
    '';
  };
  
  # Direnv for project-specific environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}