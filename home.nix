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
    #mullvad-vpn
    qbittorrent
    #ciscoPacketTracer8
    vesktop
    davinci-resolve
    gh
    git
    gh
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # LEER DOCUMENTACION ANTES DE CAMBIAR ESTO
  home.stateVersion = "23.11"; #LEER DOCUMENTACION

  programs.home-manager.enable = true;
}
