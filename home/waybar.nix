{ config, pkgs, ... }:

{
  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 18;
        margin = "5";

        # Modules
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "custom/waybar-mpris" ];
        modules-right = [ "tray" "pulseaudio" "network" "cpu" "temperature" "memory" "battery" "clock" ];

        # Module Configurations
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = ""; 
            "2" = ""; 
            "3" = ""; 
            "4" = "";
            "5" = ""; 
            "6" = "󰀫"; 
            "7" = "󰂡"; 
            "8" = "󱃮"; 
            "9" = "󰘫";
          };
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%H:%M} ";
          format-alt = "{:%d-%m-%Y} ";
        };

        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };

        "memory" = {
          format = "{}% ";
        };

        "temperature" = {
          hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
          critical-threshold = 80;
          format = "{temperatureC}°{icon}";
          format-critical = "{temperatureC}°{icon}";
          format-icons = [ "" "" "" ];
        };

        "battery" = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        "network" = {
          format-wifi = "";
          format-ethernet = "";
          format-disconnected = "睊";
        };

        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        "custom/waybar-mpris" = {
          return-type = "json";
          exec = ''
            waybar-mpris --position --autofocus --order "SYMBOL:ARTIST:TITLE:POSITION" \
              --play " :( " --pause " :3 "
          '';
          on-click = "waybar-mpris --send toggle";
          on-click-right = "waybar-mpris --send toggle";
          on-scroll-up = "waybar-mpris --send next";
          on-scroll-down = "waybar-mpris --send prev";
          escape = true;
        };
      };
    };

    # Style Configuration (CSS)
    style = ''
      * {
        font-family: "A-OTF Shin Go Pro B", "Font Awesome 6 Free", "MesloLGS Nerd Font Regular";
        font-size: 12px;
      }

      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;

      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;

      window#waybar {
        background-color: @base;
        color: @text;
        transition-property: background-color;
        transition-duration: .5s;
        border-radius: 15px;
        border-style: solid;
        border-color: @mauve;
        border-width: 2px;
      }

      #workspaces button {
        padding: 0 12px;
        border-radius: 0px;
        background-color: @surface0;
        color: #ffffff;
        margin: 2px 2px;
      }

      #workspaces button.active {
        background-color: @surface1;
        color: @mauve;
      }

      #clock {
        background-color: @surface0;
        color: @flamingo;
        border-top-right-radius: 15px;
        border-bottom-right-radius: 15px;
        margin: 2px 2px;
      }

      #battery {
        background-color: @surface0;
        color: @pink;
        margin: 2px 2px;
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

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }
    '';
  };
}
