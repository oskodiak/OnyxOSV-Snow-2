# Waybar Configuration

{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 4;
        
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/scratchpad"
        ];
        
        modules-center = [
          "sway/window"
        ];
        
        modules-right = [
          "idle_inhibitor"
          "wireplumber"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];
        
        # Module configurations
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}: {icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
        };
        
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        
        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = ["" ""];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };
        
        "sway/window" = {
          format = "{}";
          max-length = 50;
          rewrite = {
            "(.*) - Mozilla Firefox" = "🌎 $1";
            "(.*) - vim" = " $1";
            "(.*) - zsh" = " [$1]";
          };
        };
        
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        
        tray = {
          spacing = 10;
        };
        
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        
        memory = {
          format = "{}% ";
        };
        
        temperature = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        
        backlight = {
          format = "{percent}% {icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        
        wireplumber = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
    
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "Hack", monospace;
          font-size: 13px;
          min-height: 0;
      }
      
      window#waybar {
          background-color: rgba(45, 27, 78, 0.90);  /* Deep purple from wallpaper */
          border-bottom: 3px solid rgba(76, 91, 232, 0.6);  /* Snowflake blue */
          color: #f0efff;  /* Light/white from wallpaper */
          transition-property: background-color;
          transition-duration: 0.5s;
      }
      
      window#waybar.hidden {
          opacity: 0.2;
      }
      
      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #f0efff;  /* Light/white */
          border-bottom: 3px solid transparent;
      }
      
      #workspaces button:hover {
          background: rgba(76, 91, 232, 0.3);  /* Snowflake blue hover */
          box-shadow: inset 0 -3px #b8b3e6;   /* Light purple accent */
      }
      
      #workspaces button.focused {
          background-color: #4c5be8;  /* Snowflake blue */
          border-bottom: 3px solid #f0efff;  /* Light/white */
      }
      
      #workspaces button.urgent {
          background-color: #eb4d4b;  /* Keep red for urgency */
      }
      
      #mode {
          background-color: #6b5ce6;  /* Medium purple */
          border-bottom: 3px solid #f0efff;  /* Light/white */
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #wireplumber,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
          padding: 0 10px;
          color: #f0efff;  /* Light/white from wallpaper */
      }
      
      #window,
      #workspaces {
          margin: 0 4px;
      }
      
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }
      
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }
      
      #clock {
          background-color: #64727D;
      }
      
      #battery {
          background-color: #ffffff;
          color: #000000;
      }
      
      #battery.charging, #battery.plugged {
          color: #ffffff;
          background-color: #26A65B;
      }
      
      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }
      
      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
      
      label:focus {
          background-color: #000000;
      }
      
      #cpu {
          background-color: #2ecc71;
          color: #000000;
      }
      
      #memory {
          background-color: #9b59b6;
      }
      
      #disk {
          background-color: #964B00;
      }
      
      #backlight {
          background-color: #90b1b1;
      }
      
      #network {
          background-color: #2980b9;
      }
      
      #network.disconnected {
          background-color: #f53c3c;
      }
      
      #pulseaudio {
          background-color: #f1c40f;
          color: #000000;
      }
      
      #pulseaudio.muted {
          background-color: #90b1b1;
          color: #2a5c45;
      }
      
      #temperature {
          background-color: #f0932b;
      }
      
      #temperature.critical {
          background-color: #eb4d4b;
      }
      
      #tray {
          background-color: #2980b9;
      }
      
      #tray > .passive {
          -gtk-icon-effect: dim;
      }
      
      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }
      
      #idle_inhibitor {
          background-color: #2d3748;
      }
      
      #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3748;
      }
      
      #scratchpad {
          background: rgba(0, 0, 0, 0.2);
      }
      
      #scratchpad.empty {
      	background-color: transparent;
      }
    '';
  };
}