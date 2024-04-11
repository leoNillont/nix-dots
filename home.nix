{ config, pkgs, ... }:

{
  # Nombre y directorio
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
    prusa-slicer
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

  # Wayland ozone
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # LEER DOCUMENTACION ANTES DE CAMBIAR ESTO
  home.stateVersion = "23.11"; #LEER DOCUMENTACION

  programs.home-manager.enable = true;
}
