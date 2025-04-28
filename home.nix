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
    #prismlauncher
    (prismlauncher.override {
      jdks = [
        temurin-jre-bin-23
        temurin-bin-21
        temurin-jre-bin-17
        temurin-jre-bin-11
        temurin-jre-bin-8
        #jdk21
        #jdk17
        #jdk8
      ];
    })
    kitty
    rofi-wayland
    mako
    nwg-bar
    swaylock-effects
    vesktop
    r2modman
    #obs-studio
    filezilla
    qpwgraph
    #libreoffice-qt
    #hunspell
    #hunspellDicts.en_US
    #hunspellDicts.es_ES
    #temurin-bin
    #orca-slicer
    tidal-hifi
    vscode
    pavucontrol
    pamixer
    grim
    slurp
    wl-clipboard
    cliphist
    hyprshot
    gh
    oculante
    mpv
    heroic
    #element-desktop
    yt-dlp
    #kdenlive
    fastfetch
    gimp
    satty
    #bubblewrap
    protonup-qt
    anydesk
    krita
    rustup
    #obsidian
    bottles
    piper
    sidequest
    qbittorrent
    #mangohud
    #waybar
    #vlc
    waybar-mpris
    swww
    gpt4all
    parsec-bin
    ffmpeg
    vivaldi
    retroarch
    playerctl
    hyprpicker
    mcpelauncher-ui-qt
    warp-terminal
  ];

  # Configurar fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    plugins = [
      #{ name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "pure"; src = pkgs.fishPlugins.pure.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
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
    cursors = {
      enable = true;
      accent = "light";
      flavor = "mocha";
      #size = "24";
    };
    gtk = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      icon = {
        enable = true;
      };
    };
    kvantum = {
      enable = true;
      apply = true;
    };
    btop.enable = true;
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

  # Cursor theme
  #home.pointerCursor = {
  #  #enable = true;
  #  name = "Catppuccin-Mocha-Dark";
  #  package = pkgs.catppuccin-cursors.mochaDark;
  #  gtk.enable = true;
  #  x11.enable = true;
  #};

  # Configuracion de GTK
  gtk = {
    enable = true;
  #
  #  catppuccin = {
  #    enable = true;
  #    flavor = "mocha";
  #    accent = "mauve";
  #    icon = {
  #      enable = true;
  #    };
  #  };
  };

  # Configuracion de QT 
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
  #    catppuccin = {
  #      enable = true;
  #      accent = "mauve";
  #      flavor = "mocha";
  #      apply = true;
  #    };
    };
  };
  
  # Configurar btop
  programs.btop = {
    enable = true;
    #catppuccin.enable = true;
  };

  # Configurar OBS
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      #obs-studio-plugins.obs-vkcapture
      #obs-studio-plugins.obs-vaapi
      obs-studio-plugins.obs-pipewire-audio-capture
    ];
  };

  # Syncthing
  #services.syncthing = {
  #  enable = true;
  #};

  # Wayland ozone
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # LEER DOCUMENTACION ANTES DE CAMBIAR ESTO
  home.stateVersion = "23.11"; #LEER DOCUMENTACION

  programs.home-manager.enable = true;
}
