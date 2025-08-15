{ config, pkgs, ... }:

{
  # Home Assistant service
  services.home-assistant = {
    enable = true;
    
    # Use the same port as your current setup (default: 8123)
    config = {
      # Basic configuration
      homeassistant = {
        name = "Home";
        time_zone = "Europe/Berlin"; # Adjust to your timezone
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        unit_system = "metric";
        temperature_unit = "C";
      };
      
      # Enable the web interface
      http = {
        server_host = "::1";
        trusted_proxies = [ "::1" ];
        use_x_forwarded_for = true;
      };
      
      # Include these to match common setups
      frontend = {};
      config = {};
      mobile_app = {};
      history = {};
      logbook = {};
      sun = {};
      system_health = {};
      
      # Default integrations
      default_config = {};
    };
    
    # Your existing config directory will be linked here
    configDir = "/var/lib/hass";
    
    # Don't overwrite existing config
    configWritable = true;
    
    # Open firewall for Home Assistant
    openFirewall = true;
    
    # Additional packages that Home Assistant might need
    extraPackages = python3Packages: with python3Packages; [
      # Add any Python packages your integrations need
      psycopg2
      mysqlclient
    ];
    
    # Component packages (for specific integrations)
    extraComponents = [
      # Add components you use, e.g.:
      # "esphome"
      # "mqtt"
      # "zha"
      # "zwave_js"
      # "bluetooth"
      # "usb"
    ];
  };
  
  # If you use MQTT (Mosquitto)
  # services.mosquitto = {
  #   enable = true;
  #   listeners = [
  #     {
  #       port = 1883;
  #       settings = {
  #         allow_anonymous = false;
  #       };
  #       users = {
  #         homeassistant = {
  #           acl = [ "readwrite #" ];
  #           hashedPassword = "$6$yourhash";
  #         };
  #       };
  #     }
  #   ];
  # };
  
  # If you use MariaDB/MySQL for recorder
  # services.mysql = {
  #   enable = true;
  #   package = pkgs.mariadb;
  #   dataDir = "/var/lib/mysql";
  #   ensureDatabases = [ "homeassistant" ];
  #   ensureUsers = [{
  #     name = "homeassistant";
  #     ensurePermissions = {
  #       "homeassistant.*" = "ALL PRIVILEGES";
  #     };
  #   }];
  # };
  
  # Backup service for Home Assistant
  # services.restic.backups.home-assistant = {
  #   enable = true;
  #   paths = [ "/var/lib/hass" ];
  #   repository = "/backup/home-assistant"; # Adjust backup location
  #   passwordFile = "/etc/nixos/secrets/restic-password";
  #   timerConfig = {
  #     OnCalendar = "daily";
  #     Persistent = true;
  #   };
  #   pruneOpts = [
  #     "--keep-daily 7"
  #     "--keep-weekly 4"
  #     "--keep-monthly 12"
  #   ];
  # };
  
  # Create systemd service to link config on first boot
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
      mkdir -p /var/lib/hass
      
      # Symlink YAML config files from nixos repo
      if [ -d /etc/nixos/homeassistant_cfg ]; then
        echo "Linking configuration files from repo..."
        
        # Symlink all YAML files
        for file in /etc/nixos/homeassistant_cfg/*.yaml; do
          if [ -f "$file" ]; then
            filename=$(basename "$file")
            ln -sf "$file" "/var/lib/hass/$filename"
            echo "Linked $filename"
          fi
        done
        
        # Copy blueprints directory (needs to be writable)
        if [ -d /etc/nixos/homeassistant_cfg/blueprints ]; then
          cp -r /etc/nixos/homeassistant_cfg/blueprints /var/lib/hass/
          echo "Copied blueprints directory"
        fi
        
        # Ensure proper ownership
        chown -R hass:hass /var/lib/hass
        
        echo "Home Assistant configuration linked from repo."
      else
        echo "No configuration found at /etc/nixos/homeassistant_cfg"
        echo "Please add your configuration to the repo"
      fi
    '';
  };
}
