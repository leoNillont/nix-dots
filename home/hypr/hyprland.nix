{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      monitor = [
        "eDP-1,highrr,0x0,1.333333"
        "DP-1,highrr,0x0,1,vrr,1"
        "HDMI-A-1,1920x1080@60,2560x-360,1,transform,3"
        #",1920x1080@60,auto,1,mirror,DP-1"
        #"HDMI-A-2,1920x1080@60,0x1080,1"
      ];
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
        "$mod control, o, resizeactive, 40 40"
        "$mod control, e, resizeactive, 0 -40"
        "$mod control, i, resizeactive, 0 40"
        "$mod, F, fullscreen,"
        "$mod, J, togglesplit,"
        "$mod, space, togglefloating,"
        "$mod, P, pin"

        # Workspace especial
        "$mod, t, togglespecialworkspace,"
        "$mod SHIFT, t, movetoworkspace, special"

        # Teclas de control de volumen y media
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        '', XF86MonBrightnessUp, exec, busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight RaiseAll "d(bdu)s" 0.05 0 0 0 ""''
        '', XF86MonBrightnessDown, exec, busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight LowerAll "d(bdu)s" 0.05 0 0 0 ""''

        # Swaylock
        "$mod, L, exec, swaylock --effect-blur 10x4 -S"

        # Apps
        "$mod, X, exec, thunar"
        "$mod, B, exec, firefox"

        # Screenshots
        ", Print, exec, grim"
        "$mod SHIFT, S, exec, hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copysave area; hyprctl keyword animation 'fadeOut,1,4,default'"
        "$mod CONTROL, S, exec, satty --filename $(grimblast --notify copysave area)"

        # Power menu
        "$mod SHIFT, F, exec, nwg-bar"

        # GPU-SCREEN-RECORDER
        "$mod, G, exec, ~/.config/hypr/replay/guardar.sh"
        "$mod SHIFT, G, exec, nwg-bar -t ~/.config/hypr/replay/nwg-bar/bar.json"
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
        #force_no_accel = true;
        touchpad = {
          disable_while_typing = true;
        };
      };
      
      # Autostart
      exec-once = [
        "waybar"
        "mako"
        "[workspace 1 silent] kitty"
        "[workspace 2 silent] firefox"
        "[workspace 4 silent] vesktop"
        "[workspace 5 silent] steam -silent"
        # Wayland cliphist
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        #"[workspace 3 silent] mullvad-gui"
        "lxqt-policykit-agent"
        #"brightnessctl set $(cat /sys/bus/iio/devices/iio\:device0/in_illuminance_raw)"
      ];

      # Decoraciones (Blur, Opacidad, Redondeo, etc)
      decoration = {
        rounding = "15";
        inactive_opacity = "0.85";
        blur = {
          enabled = true;
          size = "7";
          passes = "2";
          new_optimizations = true;
          #ignore_opacity = true;
          noise = 0.01;
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
        #allow_tearing = true;
      };

      # Miscelano
      misc = {
        vrr = 1;
        animate_manual_resizes = true;
        force_default_wallpaper = "2";
      };
      
      # Windowrules
      windowrulev2 = [
        "workspace 1, class:kitty"
        "workspace 2, class:firefox"
        "workspace 3, class:tidal-hifi"
        "workspace 4, class:vesktop"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        #"immediate, class:^(cs2)$"
      ];

      # Render
      render = {
        direct_scanout = true;
        #explicit_sync = 1;
        #explicit_sync_kms = 0;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      cursor = {
        no_break_fs_vrr = true;
	      min_refresh_rate = "48";
        enable_hyprcursor = false;
        no_hardware_cursors = true;
      };

      # Activar logs
      #debug.disable_logs = false;

      # Variables de entorno
      env = [
      #  "WLR_DRM_NO_ATOMIC,1"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      # Configuracion para dwindle
      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };
    };
  };
}
