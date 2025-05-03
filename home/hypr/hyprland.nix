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
      ];

      # Keybinds
      "$mod" = "SUPER";
      bind = [
        # Terminal
        "$mod, Return, exec, kitty"

        # Exit things
        "$mod, q, killactive,"
        "$mod, m, exit,"

        # Rofi
        "$mod, r, exec, rofi -show drun"
        "$mod, w, exec, rofi -show window"
        "$mod, v, exec, rofi -show clipboard"

        # Manage windows
        "$mod, n, movefocus, l"
        "$mod, o, movefocus, r"
        "$mod, e, movefocus, u"
        "$mod, i, movefocus, d"
        "$mod shift, n, movewindow, l"
        "$mod shift, o, movewindow, r"
        "$mod shift, e, movewindow, u"
        "$mod shift, i, movewindow, d"
        "$mod, F, fullscreen,"
        "$mod, J, togglesplit,"
        "$mod, space, togglefloating,"
        "$mod, P, pin"

        # Special workspace
        "$mod, t, togglespecialworkspace,"
        "$mod SHIFT, t, movetoworkspace, special"

        # Lock
        "$mod, L, exec, hyprlock"

        # Apps
        "$mod, X, exec, thunar"
        "$mod, B, exec, vivaldi"

        # Screenshots
        ", Print, exec, hyprshot -m output --freeze"
        "$mod SHIFT, S, exec, hyprshot -m region --freeze"
        "$mod CONTROL, S, exec, hyprshot -m region --freeze --raw | satty --filename -"
        "$mod ALT, S, exec, hyprshot -m window --freeze"

        # Power menu
        "$mod SHIFT, F, exec, nwg-bar"

        # GSR
        "$mod, G, exec, ~/.config/hypr/replay/save.sh"
        "$mod SHIFT, G, exec, nwg-bar -t ~/.config/hypr/replay/nwg-bar/bar.json"
      ] ++ (
        # Worspace switching
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

      # Binds that repeat
      binde = [
        # Media
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        '', XF86MonBrightnessUp, exec, busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight RaiseAll "d(bdu)s" 0.05 0 0 0 ""''
        '', XF86MonBrightnessDown, exec, busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight LowerAll "d(bdu)s" 0.05 0 0 0 ""''
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"

        # Window resizing
        "$mod control, n, resizeactive, -40 0"
        "$mod control, o, resizeactive, 40 40"
        "$mod control, e, resizeactive, 0 -40"
        "$mod control, i, resizeactive, 0 40"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "colemak";

        accel_profile = "flat";
        mouse_refocus = false;
        touchpad = {
          disable_while_typing = true;
        };
      };

      exec-once = [
        "waybar"
        "mako"
        "[workspace 1 silent] kitty"
        "[workspace 2 silent] vivaldi"
        "[workspace 4 silent] vesktop"
        "[workspace 5 silent] steam -silent"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "lxqt-policykit-agent"
        "swww-daemon"
        #"~/.config/hypr/replay/start.sh" # Uncomment to enable GSR on start
      ];

      decoration = {
        rounding = "15";
        inactive_opacity = "0.9";
        blur = {
          enabled = true;
          size = "7";
          passes = "2";
          new_optimizations = true;
          noise = 0.01;
          brightness = 0.90;
        };
      };

      animations = {
        enabled = true;
        
        "bezier" = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 0.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
        ];
      };

      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(cba6f7)";
        "col.inactive_border" = "rgb(45475a)";
      };

      misc = {
        vfr = 1;
        vrr = 1;
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        force_default_wallpaper = "2";
      };

      windowrule = [
        "workspace 1, class:kitty"
        "workspace 2, class:firefox"
        "workspace 2, class:vivaldi"
        "workspace 3, class:tidal-hifi"
        "workspace 4, class:vesktop"
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      render = {
        direct_scanout = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      cursor = {
        enable_hyprcursor = false;
      };

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };
    };
  };
}