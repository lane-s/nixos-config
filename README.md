# 🚀 lspangler's Development Environment

Dead-simple, universal configuration that works anywhere - NixOS, macOS, or any Linux distribution.

## Quick Start

**One-liner deployment:**
```bash
curl -L https://raw.githubusercontent.com/lspangler/init-env/main/bootstrap.sh | bash
```

**For NixOS - clone directly to /etc/nixos:**
```bash
sudo git clone https://github.com/lspangler/init-env.git /etc/nixos
cd /etc/nixos
sudo nixos-rebuild switch --flake .#lsp-desktop
```

**For macOS/Linux - use bootstrap:**
```bash
git clone https://github.com/lspangler/init-env.git ~/.init-env
cd ~/.init-env
./bootstrap.sh
```

That's it! The script detects your OS and sets up everything automatically.

## What You Get

### **NixOS Systems**
- Complete system configuration with Hyprland window manager
- Dual-monitor workspace management with synchronized switching
- Automatic application layout (development, browser, monitoring workspaces)
- Clone this repo directly to `/etc/nixos` (no symlinks!)

### **macOS & Linux Systems**  
- Nix package manager with flake support
- home-manager for dotfile management
- Cross-platform Doom Emacs configuration
- Development tools and shell environment

### **Universal Features**
- 🎯 **Doom Emacs** - Fully configured with org-roam, LSP, development packages
- 🔧 **Development Stack** - Git, compilers, language servers, debugging tools  
- 🖼️ **Beautiful Setup** - Custom fonts, themes, wallpapers
- ⚡ **Fast Workflow** - Optimized keybindings and window management
- 🔄 **Stay in Sync** - Git-based configuration management

## How It Works

The bootstrap script:
1. **Detects your operating system** (NixOS, macOS, Ubuntu, etc.)
2. **Installs Nix** if not present (with flake support)
3. **Runs OS-specific setup** from the `install/` directory
4. **Configures your environment** using this repository

### NixOS
- Clone this repo directly to `/etc/nixos`
- Your system config IS this Git repo
- `nixos-rebuild switch --flake .#lsp-desktop` applies changes

### macOS/Linux
- Installs Nix package manager
- Uses home-manager for user environment
- Consistent tooling across different base systems

## Repository Structure

This repository IS the NixOS configuration. Clone it directly to `/etc/nixos`:

```
/etc/nixos/  (this repo)
├── flake.nix              # Main flake definition
├── hosts/                 # Machine-specific configs
│   └── lsp-desktop/       # Desktop configuration
├── home/                  # Home-manager modules  
├── modules/               # Reusable system modules
├── homeassistant_cfg/     # Home Assistant config
├── .doom.d/               # Doom Emacs configuration
├── bootstrap.sh           # Universal setup script
└── install/               # OS-specific installers
```

## Daily Usage

### Making Changes

**NixOS:**
```bash
# Edit any file directly in /etc/nixos/
vim /etc/nixos/home/hyprland.nix

# Apply system changes
sudo nixos-rebuild switch --flake /etc/nixos

# Apply user changes  
home-manager switch --flake ~/.init-env
```

**macOS/Linux:**
```bash
# Edit configurations
vim ~/.init-env/nixos/home/emacs.nix

# Apply changes
home-manager switch --flake ~/.init-env
```

### Staying Updated
```bash
cd ~/.init-env
git pull origin main
./bootstrap.sh  # Re-run to apply updates
```

## Customization

1. **Fork this repository** to your GitHub account
2. **Update the `REPO_URL`** in `bootstrap.sh` to point to your fork
3. **Modify configurations** in the `nixos/` directory
4. **Deploy anywhere** with your personalized setup

## Advanced Features

- **Hardware Detection** - Automatically configures graphics, monitors, input devices
- **Secrets Management** - Template-based setup for SSH keys, API tokens
- **Rollback Safety** - Nix generations let you undo any change
- **Multi-Machine Sync** - Same config works on laptop, desktop, servers
- **Development Ready** - Pre-configured for Rust, Python, C++, TypeScript, etc.

## Troubleshooting

**Test before applying:**
```bash
# NixOS
sudo nixos-rebuild dry-build --flake /etc/nixos

# home-manager  
home-manager build --flake ~/.init-env/nixos
```

**Rollback if needed:**
```bash
# NixOS
sudo nixos-rebuild --rollback

# home-manager
home-manager generations  # list generations
home-manager switch --flake ~/.init-env --switch-generation 42
```

**Common issues:**
- **Flakes not enabled**: Add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`
- **Permission errors**: Ensure `/etc/nixos` symlink is owned by root
- **Build failures**: Check `nixos-rebuild dry-build` first to catch errors

## Migration from Legacy

If you're upgrading from the old Guix-based setup, your old configs are safely archived in `legacy/`. The new system is completely independent - no manual migration needed, just run the new bootstrap script.