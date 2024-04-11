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
    r2modman
    vlc
    obs-studio
    filezilla
    gpu-screen-recorder
    qpwgraph
    meslo-lgs-nf
    spotify
  ];

  # Pescao
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

  # Neovim
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
