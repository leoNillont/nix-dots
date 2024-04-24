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
}
