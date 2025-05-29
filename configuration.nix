{ config, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  nixpkgs.config.allowUnfree = true; # Allow unfree packages

  home-manager.backupFileExtension = "hmbak"; # Backup file extension

  # Bootloader related configuration
  boot = {
    bootspec.enable = true;
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
    thefuck.enable = true; # Command error correction
    gpu-screen-recorder.enable = true; # Required for screen recording
    fish.enable = true;
    htop.enable = true;
    git.enable = true;
    #file-roller.enable = true; # File archiver
    java = {
      enable = true;
      package = pkgs.temurin-jre-bin-21;
    };
    steam.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    virt-manager.enable = true; # QEMU/KVM
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    uwsm.enable = true;
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ]; # For file picker
    };
    mime.enable = true;
    menus.enable = true;
  };
  virtualisation.libvirtd.enable = true; # Enable libvirt daemon

  # Hardware and power management
  hardware = {
    xpadneo.enable = true; # Xbox controller driver
    enableAllFirmware = true;
    wirelessRegulatoryDatabase = true; # Required for framework laptop
  };
  powerManagement.powertop.enable = true; # Enable powertop
  zramSwap  = {
    enable = true;
    priority = 5; # Prefer Zram over swap
    memoryPercent = 50;
    algorithm = "zstd"; # Better performance/compression ratio
  };

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd"; # Improves WiFi stability
        powersave = true;
      };
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false; # Reduces boot time
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="ES"
  '';

  services = {
    ratbagd.enable = true; # Required for piper
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
    };
    flatpak.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      settings.General.DisplayServer = "wayland";
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "colemak";
      };
    };
  };
  security.rtkit.enable = true; # Required for pipewire

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.space-mono
      iosevka
      nerd-fonts.iosevka
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
    kdiskmark
    pulseaudio
    brightnessctl
    gpu-screen-recorder
  ];

  # dolphin mime type fix
  environment.etc."/xdg/menus/applications.menu".text = builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Make apps run natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # State version
  system.stateVersion = "23.11"; # Do not change
}
