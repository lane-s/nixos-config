{ config, pkgs, ... }:

{
  # Ghostty terminal configuration
  home.file.".config/ghostty/config" = {
    text = ''
      # Font configuration
      font-family = JetBrainsMono Nerd Font
      font-size = 16
      
      # Colors (Copland OS Enterprise theme)
      background = 1f2348
      foreground = 8fc5ff
      
      # ANSI Colors matching Copland theme
      palette = 0=#2a2d5e
      palette = 1=#ff6b9d
      palette = 2=#66d9ef
      palette = 3=#f4e04d
      palette = 4=#5c9fff
      palette = 5=#c678dd
      palette = 6=#46d9ff
      palette = 7=#a8c4e6
      palette = 8=#4a5080
      palette = 9=#ff92b0
      palette = 10=#7ee8fa
      palette = 11=#ffe66d
      palette = 12=#72b3ff
      palette = 13=#e6a8ff
      palette = 14=#6ae4ff
      palette = 15=#c5d9f0
      
      # Selection colors
      selection-background = 5c9fff
      selection-foreground = 1f2348
      
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