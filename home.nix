{ pkgs, lib, ... }:

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
    hyfetch

    # GUI
    filezilla
    qpwgraph
    pavucontrol
    #oculante
    mpv
    vlc
    gimp
    kitty
    anydesk
    bottles
    vivaldi
    floorp-bin
    waypaper
    kdePackages.filelight
    (discord-ptb.override {
      withOpenASAR = true;
      withVencord = true;
    })
    orca-slicer
    prusa-slicer
    #winboat
    easyeffects
    qbittorrent
    tidal-hifi
    lmstudio
    krita
    #freecad
    
    # Gaming
    parsec-bin
    #heroic
    (prismlauncher.override {
      jdks = [
        temurin-jre-bin-21
        temurin-jre-bin-17
        temurin-jre-bin-8
        temurin-jre-bin-25
        temurin-jre-bin
      ];
      additionalPrograms = [ vlc ];
      additionalLibs = [ vlc opencl-headers ocl-icd ];
    })
    r2modman

    # Dev
    rustup
    vscode

    # Misc
    grim
    slurp
    nwg-bar
    playerctl
    mako
    swaybg
    hyprpaper
    hyprpolkitagent
    waybar-mpris
    rofi
    hyprshot
    satty
    hyprlock
    hyprpicker
    shared-mime-info
    file-roller
  ];

  # XDG User Directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # MIME Types
  xdg.mimeApps.associations.added = {
    "inode/directory" = [ "pcmanfm.desktop" ];
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
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
    };

    btop.enable = true;

    home-manager.enable = true; # probably don't want to remove this :3
    
    yazi = {
      enable = true;
      enableFishIntegration = true;
      keymap = {
        mgr.prepend_keymap = [
          { run = "plugin mount"; on = [ "M" ]; }
        ];
      };
      settings = {
        mgr = {
          show_hidden = true;
          show_symlink = true;
          prepend_keymap = [
            { on = [ "<C-n>" ]; run = ''shell -- dragon-drop -x -i -T "$0"''; } #ts don't work pmo
          ];
        };
        plugins.prepend_fetchers = [
          { id = "git"; name = "*"; run = "git"; }
          { id = "git"; name = "*/"; run = "git"; }
        ];
      };
      plugins = {
        git = pkgs.yaziPlugins.git;
        mount = pkgs.yaziPlugins.mount;
      };
      initLua = ''require("git"):setup()'';
    };
  };

  home.shell.enableFishIntegration = true;

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
    accent = "mauve";
    cursors = {
      enable = true;
      accent = "dark";
      flavor = "mocha";
    };
    kvantum = {
      enable = false;
      apply = false;
    };
    vivaldi.enable = false;
  };
  
  stylix = {
    targets = {
      waybar.enable = true;
      btop.enable = false;
      kitty.enable = false;
      yazi.enable = false;
    };
  };

  gtk.enable = true;

  # Session Variables
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # State Version
  home.stateVersion = "23.11"; # Don't change this
}
