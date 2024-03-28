{ config, pkgs, ... }:

{
  # Name and directory
  home.username = "leonillo";
  home.homeDirectory = "/home/leonillo";

  home.packages = with pkgs; [
    neofetch
    firefox
    prismlauncher
    #kitty
    #waybar
    #rofi-wayland
    flameshot
    qbittorrent
    ciscoPacketTracer8
    vesktop
    davinci-resolve
    gh
    git
    gh
    spotify
    r2modman
    vlc
    obs-studio
    filezilla
    gpu-screen-recorder
    qpwgraph
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # Wayland ozone
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # LEER DOCUMENTACION ANTES DE CAMBIAR ESTO
  home.stateVersion = "23.11"; #LEER DOCUMENTACION

  programs.home-manager.enable = true;
}
