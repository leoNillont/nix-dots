{ config, pkgs, inputs, ... }:

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
    kdePackages.kdenlive
    blender-hip
    waypaper
    kdePackages.konsole
    kdePackages.dolphin
    
    # Gaming
    parsec-bin
    mcpelauncher-ui-qt
    retroarch
    heroic
    (prismlauncher.override {
      jdks = [
        graalvmPackages.graalvm-oracle
        graalvmPackages.graalvm-ce
        temurin-jre-bin-23
        temurin-bin-21
        temurin-jre-bin-17
        temurin-jre-bin-11
        temurin-jre-bin-8
      ];
    })
    ryubing

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
    swaybg
    mpvpaper
    hyprpaper
    hyprpolkitagent
    waybar-mpris
    rofi-wayland
    hyprshot
    satty
    hyprlock
    hyprpicker
    kdePackages.dolphin-plugins
    kdePackages.qtsvg
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.kdesdk-thumbnailers
    kdePackages.ffmpegthumbs
    kdePackages.kimageformats
    kdePackages.qtimageformats
    kdePackages.kdegraphics-thumbnailers
    kdePackages.qtsvg
    kdePackages.kservice
    kdePackages.ark
    shared-mime-info
  ];

  # XDG User Directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # MIME Types
  xdg.mimeApps.associations.added = {
    "inode/directory" = [ "dolphin.desktop" ];
  };

  # Programs
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
      plugins = [
        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
        { name = "done"; src = pkgs.fishPlugins.done.src; }
        { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
        { name = "z"; src = pkgs.fishPlugins.z.src; }
      ];
    };

    btop.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-vertical-canvas
        obs-vaapi
      ];
    };

    home-manager.enable = true; # probably don't want to remove this :3
    
    spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        shuffle
        loopyLoop
      ];
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
        lyricsPlus
        newReleases
        ncsVisualizer
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
      windowManagerPatch = true;
    };
  };

  # File Configurations
  home.file = {
    "./.config/nwg-bar" = {
      source = ./home/nwg-bar;
      recursive = true;
    };
    "./.config/mako" = {
      source = ./home/mako;
      recursive = true;
    };
    "./.config/rofi" = {
      source = ./home/rofi;
      recursive = true;
    };
    "./.local/share/rofi/themes" = {
      source = ./home/rofi-theme;
      recursive = true;
    };
    "./.config/hypr/replay" = {
      source = ./home/hypr/replay;
      recursive = true;
    };
    "./.config/hypr/hyprlock.conf".source = ./home/hypr/hyprlock.conf;
    "./.config/xdg-desktop-portal/hyprland-portals.conf".source = ./home/hypr/hyprland-portals.conf;
    "./.config/hypr/xdph.conf".source = ./home/hypr/xdph.conf;
  };

  # Catppuccin Theme Configuration
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "pink";
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
    mako.enable = false; # This fixes a temporary issue due to changes in home-manager https://github.com/nix-community/home-manager/issues/6971
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
