{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    #theme = "Catppuccin-Mocha";
    settings = {
      font_size = "12.0";
      background_opacity = "0.7";
      term = "xterm-256color";
      confirm_os_window_close = "-1";
      font_family = "A-OTF Shin Go Pro";
    };
  };
}
