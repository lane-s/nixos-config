{ config, pkgs, ... }:

{
  # Btop configuration with Copland OS Enterprise theme
  programs.btop = {
    enable = true;
    settings = {
      # General settings
      color_theme = "Default";  # We'll override with custom colors
      theme_background = false;
      truecolor = true;
      
      # Update frequency
      update_ms = 1000;
      
      # Process settings
      proc_tree = true;
      proc_colors = true;
      proc_gradient = true;
      
      # CPU settings
      cpu_graph_upper = "total";
      cpu_graph_lower = "total";
      
      # Memory settings
      mem_graphs = true;
      show_swap = true;
      
      # Network settings
      net_download = 100;
      net_upload = 100;
      net_auto = true;
      
      # Battery settings
      show_battery = true;
      
      # Disk settings
      disk_free_priv = false;
      show_disks = true;
      
      # Process list settings
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_per_core = true;
      proc_mem_bytes = true;
    };
  };
  
  # Create custom Copland theme for btop
  home.file.".config/btop/themes/copland.theme" = {
    force = true;  # Overwrite existing files
    text = ''
      # Copland OS Enterprise Theme for btop
      # By lspangler
      
      # Main background colors
      theme[main_bg]="#1f2348"
      theme[main_fg]="#8fc5ff"
      
      # Title and border colors
      theme[title]="#8fc5ff"
      theme[hi_fg]="#46d9ff"
      theme[selected_bg]="#2a2d5e"
      theme[selected_fg]="#6ae4ff"
      theme[inactive_fg]="#4a5080"
      theme[graph_text]="#a8c4e6"
      
      # CPU colors (gradient from dark blue to bright cyan)
      theme[cpu_box]="#5c9fff"
      theme[cpu_core]="#46d9ff"
      theme[cpu_graph_low]="#2a2d5e"
      theme[cpu_graph_mid]="#5c9fff"
      theme[cpu_graph_high]="#46d9ff"
      
      # Memory colors
      theme[mem_box]="#66d9ef"
      theme[mem_graph]="#66d9ef"
      theme[mem_used]="#66d9ef"
      theme[mem_available]="#4a5080"
      theme[mem_cached]="#7ee8fa"
      theme[mem_free]="#2a2d5e"
      
      # Process colors
      theme[proc_box]="#72b3ff"
      theme[proc_misc]="#a8c4e6"
      theme[proc_gradient_1]="#2a2d5e"
      theme[proc_gradient_2]="#5c9fff"
      theme[proc_gradient_3]="#46d9ff"
      theme[proc_gradient_4]="#66d9ef"
      
      # Network colors
      theme[net_box]="#c678dd"
      theme[net_download]="#66d9ef"
      theme[net_upload]="#ff6b9d"
      
      # Disk colors
      theme[disk_box]="#e6a8ff"
      theme[disk_used]="#e6a8ff"
      theme[disk_free]="#4a5080"
      
      # Battery colors
      theme[battery_50]="#ff6b9d"
      theme[battery_70]="#f4e04d"
      theme[battery_100]="#66d9ef"
      
      # Temperature colors
      theme[temp_start]="#66d9ef"
      theme[temp_mid]="#f4e04d"
      theme[temp_end]="#ff6b9d"
    '';
  };
  
  # Set the custom theme as default
  home.activation.setBtopTheme = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ -f ~/.config/btop/btop.conf ]; then
      $DRY_RUN_CMD sed -i 's/color_theme = .*/color_theme = "copland"/' ~/.config/btop/btop.conf 2>/dev/null || true
    fi
  '';
}