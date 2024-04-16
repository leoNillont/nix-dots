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
    ciscoPacketTracer8
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
    meslo-lgs-nf
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
	"[workspace 3 silent] vesktop"
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
	  exec = "/home/leonillo/dotfiles/waybar/mediaplayer.py";
	};
      };
    };
    # Configuracion de estilo
    style = home/sytle.css;
  };

  # Wayland ozone
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # LEER DOCUMENTACION ANTES DE CAMBIAR ESTO
  home.stateVersion = "23.11"; #LEER DOCUMENTACION

  programs.home-manager.enable = true;
}
