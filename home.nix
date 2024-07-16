{ config, pkgs, ... }:

{
  # Nombre y directorio
  home.username = "leonillo";
  home.homeDirectory = "/home/leonillo";

  # Importar modulos que se hicieron demasiado largos
  imports = [
    home/waybar.nix
    home/hypr/hyprland.nix
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
    vesktop
    r2modman
    #obs-studio
    filezilla
    qpwgraph
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    hunspellDicts.es_ES
    adoptopenjdk-bin
    orca-slicer
    tidal-hifi
    vscode
    pavucontrol
    pamixer
    grim
    slurp
    wl-clipboard
    cliphist
    grimblast
    git
    gh
    oculante
    mpv
    heroic
    element-desktop
    yt-dlp
    kdenlive
    anydesk
    fastfetch
    gimp
    satty
    bubblewrap
    protonup-qt
    anydesk
    krita
    rustup
    obsidian
    bottles
    piper
    sidequest
  ];

  # Configurar fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    plugins = [
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
  };

  # Configurar Neovim
  #home.file."./.config/nvim/" = {
  #  source = ./home/nvim;
  #  recursive = true;
  #};

  # Configurar nwg-bar
  home.file."./.config/nwg-bar" = {
    source = ./home/nwg-bar;
    recursive = true;
  };

  # Configurar mako
  home.file."./.config/mako" = {
    source = ./home/mako;
    recursive = true;
  };

  # Configurar swaylock
  home.file."./.config/swaylock" = {
    source = ./home/swaylock;
    recursive = true;
  };

  # Configurar rofi 
  home.file."./.config/rofi" = {
    source = ./home/rofi;
    recursive = true;
  };
  home.file."./.local/share/rofi/themes" = {
    source = ./home/rofi-theme;
    recursive = true;
  };

  # Scripts de gpu-screen-recorder
  home.file."./.config/hypr/replay" = {
    source = ./home/hypr/replay;
    recursive = true;
  };

  # Enable catppuccin globally
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    pointerCursor = {
      enable = true;
      accent = "mauve";
      flavor = "mocha";
    };
  };

  # Mime-types
  xdg.mimeApps = {
    associations.added = {
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  # Directorios de usuario de xdg
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Configuracion de GTK
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      icon = {
        enable = true;
      };
    };
  };

  # Configuracion de QT 
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      catppuccin = {
        enable = true;
        apply = true;
      };
    };
  };
  
  # Configurar btop
  programs.btop = {
    enable = true;
    catppuccin.enable = true;
  };

  # Configurar OBS
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.obs-vkcapture
      obs-studio-plugins.obs-vaapi
      obs-studio-plugins.obs-pipewire-audio-capture
    ];
  };

  # Wayland ozone
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # LEER DOCUMENTACION ANTES DE CAMBIAR ESTO
  home.stateVersion = "23.11"; #LEER DOCUMENTACION

  programs.home-manager.enable = true;
}
