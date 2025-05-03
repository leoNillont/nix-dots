{ config, pkgs, ... }:

{
  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Home Manager settings
  home-manager.backupFileExtension = "hmbak"; # Backup file extension

  # Bootloader configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max"; # Use max resolution allowed
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    initrd.systemd.enable = true;
    kernelParams = [
      "quiet" "loglevel=3" "rd.udev.log_level=3" "systemd.show_status=auto"
      "vm.max_map_count=2147483642" "kernel.split_lock_mitigate=0"
      "net.ipv4.tcp_fin_timeout=5" "kernel.sched_cfs_bandwidth_slice_us=3000"
    ];
    kernelPackages = pkgs.linuxPackages_lqx;
  };

  # Enable and configure catppuccin globally
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  # Programs configuration
  programs = {
    thefuck.enable = true; # Command error correction
    thunderbird.enable = true;
    gpu-screen-recorder.enable = true; # Required for screen recording
    fish.enable = true; # Enable fish shell
    htop.enable = true; # Enable htop
    git.enable = true; # Enable git
    java = {
      enable = true;
      package = pkgs.temurin-jre-bin-21;
    };
    steam = {
      enable = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        xfce.thunar-volman
        xfce.thunar-archive-plugin
        xfce.thunar-media-tags-plugin
        webp-pixbuf-loader
      ];
    };
    virt-manager.enable = true; # QEMU/KVM
  };

  # Hardware and power management
  hardware = {
    xpadneo.enable = true; # Xbox controller driver
    enableAllFirmware = true;
  };
  powerManagement.powertop.enable = true; # Enable powertop

  # Networking
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Improves WiFi stability
    };
    wirelessRegulatoryDatabase = true; # Required for framework laptop
  };
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="ES"
  '';

  # System services
  services = {
    ratbagd.enable = true; # Required for piper
    resolved = {
      enable = true;
      dnssec = "true";
    };
    tumbler.enable = true; # Thumbnail generation
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    flatpak.enable = true; # Enable flatpak
    gvfs.enable = true; # Automount drives
    clight = {
      enable = true; # Automatic brightness control
      location = {
        latitude = 38.8911;
        longitude = 1.3969;
      };
    };
    displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      wayland.enable = true;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "colemak";
      };
    };
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.droid-sans-mono
      nerd-fonts.meslo-lg
      font-awesome
      meslo-lgs-nf
    ];
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting = {
        enable = true;
        autohint = true;
      };
    };
  };

  # Localization
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

  # User configuration
  users.users.leonillo = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "leoNillo";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "games" "video" ];
    initialPassword = "Patataxd4"; # Default password on install, should be changed later
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
    ranger
    clang
    pulseaudio
    libnotify
    killall
    lxqt.lxqt-policykit
    lzip
    linux-firmware
    gpu-screen-recorder
    powertop
    iwd
  ];

  # State version
  system.stateVersion = "23.11"; # Do not change
}
