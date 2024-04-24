{ config, pkgs, ... }:

{
  # Nombre y directorio
  home.username = "leonillo";
  home.homeDirectory = "/home/leonillo";

  # Importar modulos que se hicieron demasiado largos
  imports = [
    home/waybar.nix
    home/hyprland.nix
    home/kitty.nix
  ];

  home.packages = with pkgs; [
    firefox
    prismlauncher
    kitty
    waybar
    rofi-wayland
    mako
    nwg-bar
    swaylock-effects
    flameshot
    #qbittorrent
    ciscoPacketTracer8
    vesktop
    davinci-resolve
    r2modman
    vlc
    obs-studio
    filezilla
    gpu-screen-recorder
    qpwgraph
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    hunspellDicts.es_ES
    adoptopenjdk-bin
    orca-slicer
    catppuccin-kvantum
    tidal-hifi
    hyprpaper
    pcmanfm
    vscode
    pavucontrol
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
  #programs.neovim = {
  #  enable = true;
  #  extraConfig = ''
  #    set number relativenumber
  #  '';
  #  defaultEditor = true;
  #  plugins = with pkgs.vimPlugins; [
  #    #nvim-treesitter.withAllGrammars
  #    #nvim-lspconfig
  #    #mini-nvim
  #    #copilot-vim
  #    nvchad
  #    nvchad-ui
  #  ];
  #};
  
  # Git y Gh
  programs.git = {
    enable = true;
    package = pkgs.git;
  };
  programs.gh = {
    enable = true;
    package = pkgs.gh;
  };

  # Configuracion del tema del cursor
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # Configuracion de GTK
  gtk = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
	variant = "mocha";
      };
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
    };
    iconTheme = {
      package = pkgs.epapirus-icon-theme;
      name = "ePapirus-Dark";
    };
  };

  # Wayland ozone
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # LEER DOCUMENTACION ANTES DE CAMBIAR ESTO
  home.stateVersion = "23.11"; #LEER DOCUMENTACION

  programs.home-manager.enable = true;
}
