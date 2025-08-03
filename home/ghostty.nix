{ config, pkgs, ... }:

{
  # Ghostty terminal configuration
  home.file.".config/ghostty/config" = {
    text = ''
      # Font configuration
      font-family = JetBrainsMono Nerd Font
      font-size = 16
      
      # Colors (dark theme)
      background = 1e1e1e
      foreground = d4d4d4
      
      # Window
      window-padding-x = 10
      window-padding-y = 10
      
      # Cursor
      cursor-style = block
      
      # Keybindings for Claude compatibility
      keybind = shift+enter=text:\n
    '';
  };
}