{ config, pkgs, inputs, lib, ... }:

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
    };
    kernelPackages = pkgs.linuxPackages_cachyos;
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
    accent = "pink";
    flavor = "mocha";
  };

  programs = {
    pay-respects.enable = true; # Command error correction
    gpu-screen-recorder.enable = true; # Required for screen recording
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
        obs-vaapi
        obs-pipewire-audio-capture
        #obs-backgroundremoval
      ];
    };
    java = {
      enable = true;
      package = pkgs.temurin-bin;
    };
    steam.enable = true;
    steam.gamescopeSession.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    virt-manager.enable = true; # QEMU/KVM
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    uwsm.enable = true;
    #alvr = {
    #  enable = true;
    #  openFirewall = true;
    #};
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde xdg-desktop-portal-gtk ]; # For file picker
    };
    mime.enable = true;
    menus.enable = true;
  };
  virtualisation.libvirtd.enable = true; # Enable libvirt daemon

  # Hardware and power management
  hardware = {
    #xpadneo.enable = true; # Xbox controller driver
    enableAllFirmware = true;
    wirelessRegulatoryDatabase = true; # Required for framework laptop
  };
  powerManagement.powertop.enable = true; # Enable powertop
  zramSwap  = {
    enable = true;
    algorithm = "zstd"; # Better performance/compression ratio
  };

  networking = {
    wireless.iwd.enable = true;
    dhcpcd.enable = true;
    firewall.trustedInterfaces = [ "virbr0" ]; # Fixes libvirt networking
  };
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="ES"
  '';

  services = {
    resolved = {
      enable = true;
      dnssec = "allow-downgrade"; # This makes DNSSEC vulnerable to downgrade attacks, but ensures network will work, better than false I guess
    };
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
      settings.General.DisplayServer = "wayland";
    };
    xserver = {
      xkb = {
        layout = "us";
        variant = "colemak";
      };
    };
  };
  security.rtkit.enable = true; # Required for pipewire
  security.polkit.enable = true;

  fonts = {
    packages = with pkgs; [
      #nerd-fonts.fira-code
      #nerd-fonts.fira-mono
      #nerd-fonts.space-mono
      #iosevka
      #nerd-fonts.iosevka
      font-awesome
      meslo-lgs-nf
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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "games" "video" "gamemode" ];
    initialPassword = "Patataxd4"; # Default password on install, must be changed later
  };

  # System packages, installed globally
  environment.systemPackages = with pkgs; [
    vulkan-tools
    neovim
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
    iwd
    nixfmt-rfc-style
    pulseaudio
    brightnessctl
    gpu-screen-recorder
    lsfg-vk
    lsfg-vk-ui
    impala
    (jetbrains.idea-community-bin.override {
      forceWayland = true;
    })
    nix-alien
    nix-index
  ];

  nixpkgs.overlays = [
    inputs.nix-alien.overlays.default
  ];

  # dolphin mime type fix
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Make apps run natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # State version
  system.stateVersion = "25.11"; # Do not change
}
