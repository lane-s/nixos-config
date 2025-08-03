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
        time_zone = "America/New_York"; # Adjust to your timezone
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
  services.restic.backups.home-assistant = {
    enable = true;
    paths = [ "/var/lib/hass" ];
    repository = "/backup/home-assistant"; # Adjust backup location
    passwordFile = "/etc/nixos/secrets/restic-password";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
    ];
  };
  
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
      # Link the config from the repo if it doesn't exist
      if [ ! -f /var/lib/hass/configuration.yaml ]; then
        echo "Setting up Home Assistant configuration..."
        mkdir -p /var/lib/hass
        
        # Copy files from the nixos-config (will be in /etc/nixos after install)
        if [ -d /etc/nixos/homeassistant_cfg ]; then
          cp -r /etc/nixos/homeassistant_cfg/* /var/lib/hass/
          chown -R hass:hass /var/lib/hass
          chmod -R u+rw /var/lib/hass
          echo "Home Assistant configuration copied from repo."
        else
          echo "No configuration found at /etc/nixos/homeassistant_cfg"
          echo "Please manually copy your configuration to /var/lib/hass"
        fi
      fi
    '';
  };
}