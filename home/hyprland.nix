{ config, pkgs, ... }:

{
  # Hyprland configuration with Emacs-friendly keybindings
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration - dual monitor setup with single monitor fallback
      monitor = [
        # Default fallback for any unspecified monitor
        ",preferred,auto,1"
        
        # Dual monitor setup - Try swapped positions based on mouse behavior
        "DP-3,preferred,0x0,1"           # Left monitor (was right)
        "DP-1,preferred,1920x0,1"        # Right monitor (was left)
      ];
      
      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };
      
      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };
      
      # Decorations
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      
      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 3, myBezier"
          "windowsOut, 1, 3, default, popin 80%"
          "border, 1, 5, default"
          "borderangle, 1, 4, default"
          "fade, 1, 3, default"
          "workspaces, 1, 4, default"
        ];
      };
      
      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      # Key bindings - Emacs-inspired
      "$mod" = "SUPER";
      bind = [
        # Terminal
        "$mod, Return, exec, ghostty"
        
        # Emacs
        "$mod, e, exec, emacsclient -c -a emacs"
        "$mod SHIFT, e, exec, emacs"
        
        # Application launcher (like M-x in Emacs)
        "$mod, x, exec, tofi-drun | xargs hyprctl dispatch exec --"
        "$mod, p, exec, tofi-run | xargs hyprctl dispatch exec --"
        
        # Window management - Emacs-style
        "$mod, q, killactive,"
        "$mod SHIFT, q, exit,"
        "$mod, f, fullscreen, 1"
        "$mod SHIFT, f, fullscreen, 0"
        "$mod, Space, togglefloating,"
        
        # Focus movement - vim/Emacs hybrid (h=left, l=right) - swapped directions
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        
        # Window movement
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"
        
        # Monitor focus switching
        "$mod, comma, focusmonitor, -1"   # Focus previous monitor
        "$mod, period, focusmonitor, +1"  # Focus next monitor
        
        # Move window to monitor
        "$mod SHIFT, comma, movewindow, mon:-1"   # Move to previous monitor
        "$mod SHIFT, period, movewindow, mon:+1"  # Move to next monitor
        
        # Synchronized workspace switching (both monitors together)
        "$mod, 1, exec, hyprctl dispatch workspace 1 && hyprctl dispatch workspace 6"
        "$mod, 2, exec, hyprctl dispatch workspace 2 && hyprctl dispatch workspace 7"
        "$mod, 3, exec, hyprctl dispatch workspace 3 && hyprctl dispatch workspace 8"
        "$mod, 4, exec, hyprctl dispatch workspace 4 && hyprctl dispatch workspace 9"
        "$mod, 5, exec, hyprctl dispatch workspace 5 && hyprctl dispatch workspace 10"
        
        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"
        
        # Media keys
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        
        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      # Workspace assignment to monitors (synchronized pairs)
      workspace = [
        # Left monitor (DP-3): workspaces 1-5
        "1, monitor:DP-3, default:true"
        "2, monitor:DP-3"
        "3, monitor:DP-3"
        "4, monitor:DP-3"
        "5, monitor:DP-3"
        
        # Right monitor (DP-1): workspaces 6-10 (paired with 1-5)
        "6, monitor:DP-1, default:true"
        "7, monitor:DP-1"
        "8, monitor:DP-1"
        "9, monitor:DP-1"
        "10, monitor:DP-1"
      ];
      
      # Window rules for specific applications
      windowrulev2 = [
        # Float rules
        "float, class:(pavucontrol)"
        "float, class:(nm-connection-editor)"
        
        
        # Window sizing for terminals (no workspace assignment - handled by exec)
        "size 480 1080, class:(ghostty), title:^(Mprocs Terminal)$"    # Left half of left monitor
        "size 480 1080, class:(ghostty), title:^(Claude Terminal)$"    # Right half of left monitor
        "fullscreen, class:(ghostty), title:^(System Monitor)$"        # Fullscreen btop
        
        # Emacs sizing
        "fullscreen, class:(Emacs)"                                     # Fullscreen on right monitor
        "fullscreen, class:(emacs)"                                     # Case variation
      ];
      
      # Startup applications
      exec-once = [
        # Notification daemon
        "dunst"
        
        # Status bar
        "waybar"
        
        # Wallpaper (using swaybg) - Copeland image on both monitors
        "swaybg -i /etc/nixos/copeland.jpg -m fill"
        
        # Polkit agent
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];
    };
  };
  
  # Additional Wayland tools configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];
        
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
        };
        
        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };
        
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "Wired ";
          format-disconnected = "Disconnected ⚠";
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 16px;
      }
      
      window#waybar {
        background-color: rgba(43, 48, 59, 0.9);
        color: #ffffff;
      }
      
      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #ffffff;
        border-bottom: 3px solid transparent;
      }
      
      #workspaces button.active {
        background-color: #64727D;
        border-bottom: 3px solid #ffffff;
      }
    '';
  };
  
  # Notification daemon
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_width = 2;
        frame_color = "#33ccff";
      };
    };
  };
  
  # Application launcher
  home.packages = with pkgs; [
    tofi # Modern dmenu/rofi replacement for Wayland
    waybar
    dunst
    swaybg
    polkit_gnome
    brightnessctl
    playerctl
    pavucontrol
  ];
}
