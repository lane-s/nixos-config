{ config, pkgs, ... }:

{
  # Avahi for mDNS (required for HomeKit)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      userServices = true;
    };
  };

  # Open ports for HomeKit
  networking.firewall.allowedTCPPorts = [ 21063 51827 ];  # HomeKit Bridge
  networking.firewall.allowedUDPPorts = [ 5353 ];  # mDNS/Bonjour

  # Home Assistant service
  services.home-assistant = {
    enable = true;
    
    # Minimal config - actual configuration comes from YAML files
    config = {};
    
    # Your existing config directory with YAML files
    configDir = "/var/lib/hass";
    
    # Allow Home Assistant to write to the config directory
    configWritable = true;
    
    # Open firewall for Home Assistant (port 8123)
    openFirewall = true;
    
    # Additional packages that Home Assistant might need
    extraPackages = python3Packages: with python3Packages; [
      # Database support
      psycopg2
      mysqlclient
    ];
    
    # Component packages (for specific integrations)
    extraComponents = [
      # Core components
      "group"  # Group integration
      # Performance optimization
      "isal"  # Fast zlib compression
      # User requested components
      "tplink"  # TP-Link devices
      "mobile_app"  # Mobile app support
      "homekit"  # HomeKit integration
      "zeroconf"  # mDNS/Bonjour discovery (required for HomeKit)
      "upnp"  # UPnP/IGD support
      # Add other components you use, e.g.:
      # "esphome"
      # "mqtt"
      # "zha"
      # "zwave_js"
      # "bluetooth"
      # "usb"
    ];
  };
  
  # Create systemd service to copy config on first boot
  systemd.services.setup-home-assistant-config = {
    description = "Setup Home Assistant configuration";
    wantedBy = [ "multi-user.target" ];
    before = [ "home-assistant.service" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    
    script = ''
      echo "Setting up Home Assistant configuration..."
      
      # Copy entire configuration directory from nixos repo
      if [ -d /etc/nixos/homeassistant_cfg ]; then
        echo "Copying Home Assistant configuration from repo..."
        
        # Create the directory if it doesn't exist
        mkdir -p /var/lib/hass
        
        # Copy everything from the config directory
        cp -r /etc/nixos/homeassistant_cfg/. /var/lib/hass/
        
        # Ensure proper ownership for everything
        chown -R hass:hass /var/lib/hass
        
        echo "Home Assistant configuration copied from repo."
      else
        echo "No configuration found at /etc/nixos/homeassistant_cfg"
        echo "Please ensure your configuration.yaml is in that directory"
      fi
    '';
  };
}
