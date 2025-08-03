# NixOS + Hyprland Development Environment

This is a NixOS configuration that ports the Guix-based setup to NixOS with Hyprland as the window manager.

## Features

- **NixOS Flakes** for reproducible system configuration
- **Hyprland** Wayland compositor with Emacs-friendly keybindings
- **Doom Emacs** with Wayland-native support
- **Home Manager** for user-level package management
- **Dual monitor support** with automatic single monitor fallback

## Prerequisites

1. A fresh NixOS installation (minimal ISO is fine)
2. Git installed: `nix-env -iA nixos.git`
3. Flakes enabled in your NixOS configuration

## Installation

For Ubuntu/Mint → NixOS migration, see `UBUNTU-TO-NIXOS.md`

1. Clone this repository:
```bash
git clone https://github.com/lane-s/nixos-config.git ~/.init-env/nixos-config
cd ~/.init-env/nixos-config
```

2. Update the configuration files:
   - Replace `youruser` with your username in all files
   - Update hardware configuration: `sudo nixos-generate-config --show-hardware-config > hosts/lsp-desktop/hardware-configuration.nix`
   - Adjust monitor configuration in `home/hyprland.nix`

3. Build and switch to the new configuration:
```bash
sudo nixos-rebuild switch --flake .#lsp-desktop
```

4. Reboot and log in to Hyprland

5. First-time Doom Emacs setup will run automatically

## Key Bindings

### Window Management
- `Super + Return` - Open terminal (kitty)
- `Super + e` - Open Emacs client
- `Super + Shift + e` - Open new Emacs instance
- `Super + x` - Application launcher (like M-x)
- `Super + q` - Close window
- `Super + Shift + q` - Exit Hyprland
- `Super + f` - Fullscreen
- `Super + Space` - Toggle floating

### Navigation
- `Super + h/j/k/l` - Focus left/down/up/right
- `Super + Shift + h/j/k/l` - Move window left/down/up/right
- `Super + 1-9,0` - Switch to workspace 1-10
- `Super + Shift + 1-9,0` - Move window to workspace

### Screenshots
- `Print` - Screenshot selection
- `Shift + Print` - Screenshot full screen

## Updating

To update the system:
```bash
cd ~/.init-env/nixos-config
nix flake update
sudo nixos-rebuild switch --flake .#dev-machine
```

## Customization

### Monitor Setup
Edit `home/hyprland.nix` and uncomment/modify the monitor lines:
```nix
monitor = [
  ",preferred,auto,1"  # Fallback
  "DP-1,2560x1440@144,0x0,1"       # Main monitor
  "HDMI-A-1,1920x1080@60,2560x0,1" # Secondary monitor
];
```

### Packages
- System packages: `modules/base.nix`
- User packages: `home/packages.nix`

### Doom Emacs
Your Doom configuration is in `.doom.d/` and will be automatically linked.

## Differences from Guix Setup

1. **Package Manager**: Nix instead of Guix
2. **Window Manager**: Hyprland (Wayland) instead of EXWM (X11)
3. **Display Server**: Wayland instead of X11
4. **Init System**: systemd instead of GNU Shepherd
5. **Configuration Language**: Nix instead of Scheme

## Home Assistant Integration

To enable Home Assistant:
1. Uncomment the Home Assistant module in `hosts/dev-machine/configuration.nix`
2. Place your backup at `/backup/homeassistant-backup.tar.gz` before rebuilding
3. The service will automatically restore your config on first boot
4. Access Home Assistant at `http://localhost:8123`

## Migration from Other Distros

See `MIGRATION.md` for detailed instructions on migrating from Linux Mint or other distributions.

## Troubleshooting

### Wayland Issues
If some applications don't work properly:
- Electron apps: Should work with `NIXOS_OZONE_WL=1`
- Firefox: Should work with `MOZ_ENABLE_WAYLAND=1`
- For X11-only apps, XWayland is enabled by default

### Emacs Issues
- If Emacs daemon doesn't start: `systemctl --user restart emacs`
- For native compilation issues: Check `~/.cache/emacs/eln-cache`

### Performance
- Enable hardware acceleration in `hardware-configuration.nix`
- Check GPU drivers are properly configured
