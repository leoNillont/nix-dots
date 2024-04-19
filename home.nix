{ config, pkgs, ... }:

{
  # Nombre y directorio
  home.username = "leonillo";
  home.homeDirectory = "/home/leonillo";

  home.packages = with pkgs; [
    neofetch
    firefox
    prismlauncher
    kitty
    waybar
    rofi-wayland
    mako
    nwg-bar
    swaylock
    flameshot
    qbittorrent
    #ciscoPacketTracer8
    vesktop
    davinci-resolve
    gh
    git
    r2modman
    vlc
    obs-studio
    filezilla
    gpu-screen-recorder
    qpwgraph
    spotify
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    hunspellDicts.es_ES
    adoptopenjdk-bin
    orca-slicer
    catppuccin-gtk
    catppuccin-kvantum
    tidal-hifi
    python3
  ];

  # Configurar fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
  };

  # Configurar Neovim
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
    '';
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      mini-nvim
      copilot-vim
    ];
  };
  
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      monitor = "eDP-1,highrr,0x0,1";
      # Bindeos de teclas y raton
      "$mod" = "SUPER";
      bind = [
        # Terminal
        "$mod, Return, exec, kitty"

	# Cosas
	"$mod, q, killactive,"
	"$mod, m, exit,"

	# Rofi
	"$mod, r, exec, rofi -show drun"
	"$mod, w, exec, rofi -show window"
	"$mod, c, exec, rofi -show clipboard"

	# Movimiento de y entre ventanas
	"$mod, n, movefocus, l"
	"$mod, o, movefocus, r"
	"$mod, e, movefocus, u"
	"$mod, i, movefocus, d"
	"$mod shift, n, movewindow, l"
	"$mod shift, o, movewindow, r"
	"$mod shift, e, movewindow, u"
	"$mod shift, i, movewindow, d"
	"$mod control, n, resizeactive, l"
	"$mod control, o, resizeactive, r"
	"$mod control, e, resizeactive, u"
	"$mod control, i, resizeactive, d"
      ]
      ++ (
        # workspaces
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      # Configuracion de perifericos
      input = {
        # Colemak
        kb_layout = "us";
	kb_variant = "colemak";
	# Raton
	accel_profile = "flat";
	mouse_refocus = false;
      };

      # Autostart
      exec-once = [
        "waybar"
	"mako"
	"[workspace 1 silent] kitty"
	"[workspace 2 silent] firefox"
	"[workspace 4 silent] vesktop"
      ];

      # Decoraciones (Blur, Opacidad, Redondeo, etc)
      decoration = {
        rounding = "15";
	inactive_opacity = "0.85";
	blur = {
	  enabled = true;
	  size = "10";
	  passes = "2";
	  new_optimizations = true;
	  ignore_opacity = true;
	  noise = 0.1;
	  brightness = 0.90;
	};
      };

      # Animaciones
      animations = {
	enabled = true;
	"bezier" = "myBezier, 0.05, 0.9, 0.1, 1.05";
	animation = [
	  "windows, 1, 7, myBezier"
	  "windowsOut, 1, 7, default, popin 80%"
	  "border, 1, 10, default"
	  "borderangle, 1, 8, default"
	  "fade, 1, 7, default"
	  "workspaces, 1, 3, default"
	];
      };
    };
  };

  # Configurar Waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        # Posicion y altura
        layer = "top";
	position = "top";
	height = 32;

	# Modulos
	modules-left = [ "hyprland/workspaces" "hyprland/window" ];
	modules-center = [ "custom/media" ];
	modules-right = [ "tray" "pulseaudio" "network" "cpu" "temperature" "battery" "clock" ];

	# Configuracion de los modulos
	"hyprland/workspaces" = {
	  disable-scroll = true;
	  all-outputs = true;
	  format = "{icon}";
	  on-click = "activate";
	  format-icons = {
	    "1" = "";
	    "2" = "";
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
	  hwmon_path = "/sys/class/hwmon/hwmon2/temp1_input";
	  critical-threshold = 80;
	  format = "{temperatureC}°C {icon}";
	  format-critical = "{temperatureC}°C {icon}";
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
	  format-bluetooth = "{volume}% {icon} {format_source}";
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
	"custom/media" = {
	  format = "{icon} {}";
	  return-type = "json";
	  max-length = 40;
	  format-icons = {
	    spotify = "";
	    default = "🎜";
	  };
	  escape = true;
	  exec = "/home/leonillo/nixos-conf/home/waybar/mediaplayer.py";
	};
      };
    };
    # Configuracion de estilo, ubicado en home/style.css
    style = ''
      * {
        font-family: "A-OTF Shin Go Pro B", "Font Awesome 6 Free", "MesloLGS Nerd Font Regular";
        font-size: 14px;
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
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      /*
      window#waybar.empty {
        background-color: transparent;
      }
      window#waybar.solo {
        background-color: #FFFFFF;
      }
      */

      button {
        border: none;
        border-radius: 0;
      }

      button:hover {
        background: inherit;
      }

      #workspaces button {
        padding: 0 12px;
        border-radius: 0px;
        background-color: @surface0;
        color: #ffffff;
        margin: 2px 2px;
      }

      #workspaces button:hover {
        background: @surface0;
      }

      #workspaces button.active {
        background-color: @surface1;
        color: @mauve;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      #workspaces button:first-child {
        border-top-left-radius: 15px;
        border-bottom-left-radius: 15px;
        margin-left: 2px;
      }

      /* Remove margin on last button */
        #workspaces button:last-child {
        margin-right: 0px;
      }

      #mode {
        background-color: #64727D;
        border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
        padding: 0 10px;
        color: #ffffff;
      }

      #window,
      #workspaces {
        margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
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

      #battery.charging, #battery.plugged {
        color: @green;
        background-color: @surface0;
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
        background-color: @surface0;
        color: @red;
        margin: 2px 2px;
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
        background-color: @surface0;
        color: @maroon;
        margin: 2px 2px;
      }

      #network.disconnected {
        background-color: #f53c3c;
      }

      #pulseaudio {
        background-color: @surface0;
        color: @peach;
        margin: 2px 2px;
      }

      #pulseaudio.muted {
        background-color: #90b1b1;
        color: #2a5c45;
      }

      #wireplumber {
        background-color: #fff0f5;
        color: #000000;
      }

      #wireplumber.muted {
        background-color: #f53c3c;
      }

      #custom-media {
        background-color: @surface0;
        color: @green;
        min-width: 100px;
        border-radius: 15px;
        margin: 2px 0px;
      }

      #custom-media.custom-spotify {
        background-color: @surface0;
      }

      #custom-media.custom-vlc {
        background-color: #ffa000;
      }

      #temperature {
        background-color: @surface0;
        color: @mauve;
        margin: 2px 2px;
      }

      #temperature.critical {
        background-color: #eb4d4b;
      }

      #tray {
        background-color: @surface0;
        color: @text;
        border-top-left-radius: 15px;
        border-bottom-left-radius: 15px;
        margin-right: 2px;
        margin: 2px 0px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
      }     

      #idle_inhibitor {
        background-color: #2d3436;
      }

      #idle_inhibitor.activated {
        background-color: #ecf0f1;
        color: #2d3436;
      }

      #mpd {
        background-color: #66cc99;
        color: #2a5c45;
      }

      #mpd.disconnected {
         background-color: #f53c3c;
      }

      #mpd.stopped {
        background-color: #90b1b1;
      }

      #mpd.paused {
        background-color: #51a37a;
      }   

      #language {
        background: #00b093;
        color: #740864;
        padding: 0 2px;
        margin: 0 5px;
        min-width: 16px;
      }

      #keyboard-state {
        background: #97e1ad;
        color: #000000;
        padding: 0 0px;
        margin: 0 2px;
        min-width: 16px;
      }

      #keyboard-state > label {
        padding: 0 2px;
      }

      #keyboard-state > label.locked {
        background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad {
        background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad.empty {
	background-color: transparent;
      }

      /* Focused window */
      #window {
        background-color: @surface0;
        color: @text;
        border-top-right-radius: 15px;
        border-bottom-right-radius: 15px;
        padding: 0 12px;
        margin: 2px 0px;
     }
    '';
  };

  # Wayland ozone
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # LEER DOCUMENTACION ANTES DE CAMBIAR ESTO
  home.stateVersion = "23.11"; #LEER DOCUMENTACION

  programs.home-manager.enable = true;
}
