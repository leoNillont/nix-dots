{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
    package = pkgs.lixPackageSets.stable.lix;
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
      #"kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.ipv4.tcp_fin_timeout" = 5;
      "kernel.split_lock_mitigate" = 0;
      "vm.max_map_count" = 2147483642;
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
    kernelParams = [
      "zswap.enabled=0"
      "split_lock_detect=off"
    ];
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };

  systemd = {
    services.systemd-udev-settle.enable = false; # Reduces boot time
    oomd.enable = true;
    packages = with pkgs; [ arrpc ];
  };
  services.udev = {
    extraRules = ''
      ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
    '';
    packages = with pkgs; [ via ];
  };

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
      plugins = with pkgs; [
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
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    };
    java = {
      enable = true;
      package = pkgs.temurin-bin-25;
    };
    steam = {
      enable = true;
      extest.enable = true;
      remotePlay.openFirewall = true;
    };
    gamemode = {
      enable = true;
    };
    #virt-manager.enable = true; # QEMU/KVM
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
      viAlias = true;
      vimAlias = true;
    };
    xfconf.enable = true;
    starship = {
      enable = true;
    };
  };
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ]; # For file picker
      xdgOpenUsePortal = false;
    };
  };
  #virtualisation.libvirtd.enable = true; # Enable libvirt daemon
  #virtualisation.waydroid.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Hardware and power management
  hardware = {
    enableAllFirmware = true;
    wirelessRegulatoryDatabase = true; # Required for framework laptop
  };
  #powerManagement.powertop.enable = true; # Enable powertop
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd"; # Better performance/compression ratio
  };

  networking = {
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    firewall.trustedInterfaces = [ "virbr0" ]; # Fixes libvirt networking
    nameservers = [
      "9.9.9.9"
      "1.1.1.1"
    ];
  };
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="ES"
  '';

  services = {
    tlp.enable = lib.mkForce false;
    ratbagd.enable = true;
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
      settings.Resolve.DNSSEC = true;
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
    flatpak.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
    };
    xserver = {
      xkb = {
        layout = "us";
        variant = "colemak";
      };
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "leonillo" ];
      };
    };
    gnome.gnome-keyring.enable = true;
    #ollama = {
    #  enable = true;
    #  package = pkgs.ollama-vulkan;
    #};
  };

  security = {
    rtkit.enable = true; # Required for pipewire
    polkit.enable = true;
    pam.services.sddm.enableGnomeKeyring = true;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.symbols-only
      font-awesome
      meslo-lgs-nf
      noto-fonts
      noto-fonts-color-emoji
      nanum # Orca slicer crashes without ts it seems
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
    extraGroups = [
      "wheel"
      "libvirtd"
      "games"
      "video"
      "gamemode"
      "docker"
      "render"
    ];
    initialHashedPassword = "$y$j9T$ReVR1vqESFLY8Y7dkJDb/.$7piDB7IUbIgbm/16XbzfnehT.bPFy4m7RZADZSysmz0"; # Default password on install, must be changed later
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
    lzip
    linux-firmware
    powertop
    pulseaudio
    brightnessctl
    gpu-screen-recorder
    lsfg-vk
    lsfg-vk-ui
    impala
    nix-index
    fzf
    ffmpegthumbnailer
    webp-pixbuf-loader
    gdk-pixbuf
    waypipe
    xdg-utils
    glib
    distrobox
    arrpc
    inputs.affinity-nix.packages.x86_64-linux.v3
    ffmpeg
    oterm
    lazygit
    nixfmt
    statix
    sbctl
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };

  # Make apps run natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.cpu.amd.updateMicrocode = true;

  # State version
  system.stateVersion = "26.05"; # Do not change
}
