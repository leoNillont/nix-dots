{ pkgs, lib, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  nixpkgs.config.allowUnfree = true; # Allow unfree packages

  home-manager.backupFileExtension = "hmbak"; # Backup file extension

  # Bootloader related configuration
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max"; # Use max resolution allowed
        editor = false;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    initrd.systemd.enable = true;
    kernel.sysctl = {
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.ipv4.tcp_fin_timeout" = 5;
      "kernel.split_lock_mitigate" = 0;
      "vm.max_map_count" = 2147483642;
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [ "zswap.enabled=0" ];
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };
  systemd.services.systemd-udev-settle.enable = false; # Reduces boot time

  # Enable and configure catppuccin globally
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  programs = {
    pay-respects.enable = true; # Command error correction
    gpu-screen-recorder.enable = true; # Required for screen recording
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-vcs-plugin
        thunar-media-tags-plugin
      ];
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        (lib.getLib stdenv.cc.cc)
        glfw3-minecraft
        openal
        alsa-lib
        libjack2
        libpulseaudio
        pipewire
        libGL
        libx11
        libxcursor
        libxext
        libxrandr
        libxxf86vm
        udev
        vulkan-loader
      ];
    };
    fish.enable = true;
    htop.enable = true;
    git.enable = true;
    obs-studio = {
      enable = true;
      enableVirtualCamera = false;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    };
    java = {
      enable = true;
      package = pkgs.temurin-bin;
    };
    steam = {
      enable = true;
      extest.enable = true;
      remotePlay.openFirewall = true;
    };
    gamemode = {
      enable = true;
      settings.general.renice = 10;
    };
    virt-manager.enable = true; # QEMU/KVM
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    uwsm.enable = true;
    yazi = {
      enable = true;
    };
    zoxide.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    xfconf.enable = true;
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ]; # For file picker
    };
    mime.enable = true;
    menus.enable = true;
    terminal-exec = {
      enable = true;
      settings.default = [
        "kitty.desktop"
      ];
    };
  };
  virtualisation.libvirtd.enable = true; # Enable libvirt daemon
  virtualisation.waydroid.enable = true;
  #virtualisation.docker.enable = true;

  # Hardware and power management
  hardware = {
    #xpadneo.enable = true; # Xbox controller driver
    enableAllFirmware = true;
    wirelessRegulatoryDatabase = true; # Required for framework laptop
  };
  powerManagement.powertop.enable = true; # Enable powertop
  zramSwap  = {
    enable = true;
    priority = 100;
    algorithm = "zstd"; # Better performance/compression ratio
  };

  networking = {
    wireless.iwd.enable = true;
    dhcpcd.enable = true;
    firewall.trustedInterfaces = [ "virbr0" ]; # Fixes libvirt networking
    nameservers = [ "9.9.9.9" "1.1.1.1" ];
  };
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="ES"
  '';

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    tailscale = {
      enable = true;
      extraSetFlags = [ "--ssh" ];
    };
    tumbler.enable = true;
    resolved = {
      enable = true;
      dnssec = "allow-downgrade"; # This makes DNSSEC vulnerable to downgrade attacks, but ensures network will work, better than false I guess
    };
    udisks2.enable = true;
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    pulseaudio.enable = lib.mkForce false;
    flatpak.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      #package = pkgs.kdePackages.sddm;
      settings.General.DisplayServer = "wayland";
    };
    xserver = {
      xkb = {
        layout = "us";
        variant = "colemak";
      };
    };
    system76-scheduler.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "leonillo" ];
      };
    };
    desktopManager.plasma6.enable = true;
  };
  security.rtkit.enable = true; # Required for pipewire
  security.polkit.enable = true;

  fonts = {
    packages = with pkgs; [
      nerd-fonts.symbols-only
      font-awesome
      meslo-lgs-nf
      noto-fonts
      noto-fonts-color-emoji
    ];
    enableDefaultPackages = true;
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting = {
        enable = true;
        autohint = true;
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
  };

  # Locale related settings
  time.timeZone = "Europe/Madrid";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  console.keyMap = "colemak"; # Keymap outside X

  users.users.leonillo = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "leoNillo";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "games" "video" "gamemode" "docker" "render" ];
    initialPassword = "Patataxd4"; # Default password on install, must be changed later
  };

  # System packages, installed globally
  environment.systemPackages = with pkgs; [
    wget
    curl
    btop
    htop
    zip
    unzip
    p7zip
    unrar
    lm_sensors
    gcc
    libnotify
    killall
    hyprpolkitagent
    lzip
    linux-firmware
    powertop
    pulseaudio
    brightnessctl
    gpu-screen-recorder
    lsfg-vk
    lsfg-vk-ui
    impala
    (jetbrains.idea-community-bin.override {
      forceWayland = true;
    })
    nix-index
    fzf
    sidequest
    shared-mime-info
    ffmpegthumbnailer
    webp-pixbuf-loader
    ffmpeg-headless
    gdk-pixbuf
    blender-hip
    waypipe
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };

  # Make apps run natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # State version
  system.stateVersion = "25.11"; # Do not change
}
