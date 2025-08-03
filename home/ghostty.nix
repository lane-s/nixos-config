{ config, pkgs, ... }:

{
  # Ghostty terminal configuration
  home.file.".config/ghostty/config" = {
    text = ''
      # Font configuration
      font-family = JetBrainsMono Nerd Font
      font-size = 16
      
      # Theme
      theme = dark
      
      # Window
      window-decoration = true
      window-padding-x = 10
      window-padding-y = 10
      
      # Cursor
      cursor-style = block
      cursor-blink = true
    '';
  };
}