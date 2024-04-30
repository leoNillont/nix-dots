{ config, pkgs, ... }:

{
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
        "$mod, v, exec, rofi -show clipboard"

        # Movimiento de y entre ventanas
        "$mod, n, movefocus, l"
        "$mod, o, movefocus, r"
        "$mod, e, movefocus, u"
        "$mod, i, movefocus, d"
        "$mod shift, n, movewindow, l"
        "$mod shift, o, movewindow, r"
        "$mod shift, e, movewindow, u"
        "$mod shift, i, movewindow, d"
        "$mod control, n, resizeactive, -40 0"
        "$mod control, o, resizeactive, 0 40"
        "$mod control, e, resizeactive, 0 -40"
        "$mod control, i, resizeactive, 40 0"
        "$mod, F, fullscreen,"
        "$mod, J, togglesplit"
        "$mod, space, togglefloating,"
        "$mod, P, pin"

        # Workspace especial
        "$mod, t, togglespecialworkspace,"
        "$mod SHIFT, t, movetoworkspace, special"

        # Teclas de control de volumen y media
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"

        # Teclas de brillo
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set -5%"
        
        # Swaylock
        "$mod, L, exec, swaylock --effect-blur 10x4 -S"

        # Apps
        "$mod, X, exec, pcmanfm"
        "$mod, B, exec, firefox"

        # Screenshots
        ", Print, exec, grim"
        "$mod SHIFT, S, exec, grim -g $(slurp) - | wl-copy"

        # Power menu
        "$mod SHIFT, F, exec, nwg-bar"
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
        "[workspace 4 silent] sleep 1 & vesktop --enable-features=VaapiIgnoreDriverChecks,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,UseMultiPlaneFormatForHardwareVideo,UseOzonePlatform --ozone-platform=wayland"
        "steam -silent"
        # Wayland cliphist
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
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

      # General
      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(cba6f7)";
        "col.inactive_border" = "rgb(45475a)";
      };

      # Miscelano
      misc = {
        vrr = 1;
        animate_manual_resizes = true;
        no_direct_scanout = false;
      };
      
      
      # Windowrules
      windowrulev2 = [
        "workspace 1, class:kitty"
        "workspace 2, class:firefox"
        "workspace 3, class:tidal-hifi"
        "workspace 4, class:vesktop"
      ];
    };
  };
}
