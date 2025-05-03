{ config, pkgs, ... }:

{
  # Import Modules
  imports = [
    home/waybar.nix
    home/hypr/hyprland.nix
    home/kitty.nix
  ];

  # User Information
  home.username = "leonillo";
  home.homeDirectory = "/home/leonillo";

  # Packages
  home.packages = with pkgs; [
    # CLI
    gh
    yt-dlp
    fastfetch
    pamixer
    wl-clipboard
    cliphist 
    ffmpeg

    # GUI
    vesktop
    filezilla
    qpwgraph
    tidal-hifi
    pavucontrol
    oculante
    mpv
    gimp
    krita
    qbittorrent
    kitty
    protonup-qt
    anydesk
    bottles
    piper
    sidequest
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    })
    
    # Gaming
    parsec-bin
    mcpelauncher-ui-qt
    retroarch
    heroic
    (prismlauncher.override {
      jdks = [
        temurin-jre-bin-23
        temurin-bin-21
        temurin-jre-bin-17
        temurin-jre-bin-11
        temurin-jre-bin-8
      ];
    })

    # Dev
    rustup
    vscode

    # Misc
    grim
    slurp
    nwg-bar
    playerctl
    mako
    swww
    waybar-mpris
    rofi-wayland
    hyprshot
    satty
    hyprlock
    hyprpicker
  ];

  # XDG User Directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # MIME Types
  xdg.mimeApps.associations.added = {
    "inode/directory" = [ "thunar.desktop" ];
  };

  # Programs
  programs = {
    # Fish Shell Configuration
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
      plugins = [
        { name = "pure"; src = pkgs.fishPlugins.pure.src; }
        { name = "done"; src = pkgs.fishPlugins.done.src; }
        { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
        { name = "z"; src = pkgs.fishPlugins.z.src; }
      ];
    };

    # Btop Configuration
    btop.enable = true;

    # OBS Studio Configuration
    obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };

    # Enable Home Manager
    home-manager.enable = true;
  };

  # File Configurations
  home.file."./.config/nwg-bar" = {
    source = ./home/nwg-bar;
    recursive = true;
  };
  home.file."./.config/mako" = {
    source = ./home/mako;
    recursive = true;
  };
  home.file."./.config/swaylock" = {
    source = ./home/swaylock;
    recursive = true;
  };
  home.file."./.config/rofi" = {
    source = ./home/rofi;
    recursive = true;
  };
  home.file."./.local/share/rofi/themes" = {
    source = ./home/rofi-theme;
    recursive = true;
  };
  home.file."./.config/hypr/replay" = {
    source = ./home/hypr/replay;
    recursive = true;
  };

  # Catppuccin Theme Configuration
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    cursors = {
      enable = true;
      accent = "light";
      flavor = "mocha";
    };
    gtk = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
      icon.enable = true;
    };
    kvantum = {
      enable = true;
      apply = true;
    };
    btop.enable = true;
  };

  # GTK Configuration
  gtk.enable = true;

  # QT Configuration
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Session Variables
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # State Version
  home.stateVersion = "23.11"; # Don't change this
}
