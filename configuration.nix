{ config, pkgs, ... }:


{
  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Sometimes needed for home-manager to backup certain files
  home-manager.backupFileExtension = "hmbak";

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max"; # Run bootloader at max res
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
    initrd.systemd.enable = true;
    #initrd.compressor = "lz4";
  
    #plymouth.enable = true;
    kernelParams = [ "quiet" "loglevel=3" "rd.udev.log_level=3" "systemd.show_status=auto" "vm.max_map_count=2147483642" "kernel.split_lock_mitigate=0" "net.ipv4.tcp_fin_timeout=5" "kernel.sched_cfs_bandwidth_slice_us=3000" ];

  };

  # Activar kernel linux-zen
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enable catppuccin
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  # Ollama, for LLMs
  #services.ollama = {
  #  enable = true;
  #  # Acceleration options go per host
  #};

  # Thefuck, command error correction but funny
  programs.thefuck.enable = true;

  # Enable zram
  zramSwap.enable = true;

  # Xpadneo, a driver for xbox controllers
  hardware.xpadneo.enable = true;

  # Powertop
  powerManagement.powertop.enable = true;

  # Mullvad VPN
  #services.mullvad-vpn = {
  #  enable = true;
  #  package = pkgs.mullvad-vpn; # Changes the package, so we can get a GUI instead of CLI
  #};

  # Ratbagd, service needed for piper
  services.ratbagd.enable = true;

  # ALVR, for quest 3
  programs.alvr = {
    #enable = true;
    #openFirewall = true;
  };
  
  programs.thunderbird.enable = true;

  # If not using this, gsr will not work
  programs.gpu-screen-recorder.enable = true;

  # Thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      #ffmpegthumbnailer
      #f3d
      webp-pixbuf-loader
    ];
  };
  services.tumbler.enable = true;
  programs.file-roller.enable = true;

  # Enable fish shell
  programs.fish.enable = true;

  # Auto optimise store to save space
  nix.settings.auto-optimise-store = true;

  # Network settings
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.networkmanager.wifi.backend = "iwd"; # Improves wifi stability
  hardware.wirelessRegulatoryDatabase = true; # Needed on framework laptop
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="ES"
  ''; # Also needed on framework

  # Systemd-resolved
  services.resolved = {
    enable = true;
    dnssec = "true";
  };

  # Timezone
  time.timeZone = "Europe/Madrid";

  # Language settings
  i18n.defaultLocale = "en_US.UTF-8";

  # Make apps run natively on wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Locales 
  i18n.extraLocaleSettings = {
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

  # Change keymap to colemak outside of X
  console.keyMap = "colemak";

  # Enable and configure Xserver
  services.xserver = {
    enable = true;

    # Change keymap to colemak on X
    xkb = {
      layout = "us";
      variant = "colemak";
    };
  };

  # GVFS, automounts drives
  services.gvfs.enable = true;

  # Configure SDDM
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    #theme = "catppuccin-mocha";
    wayland.enable = true;
  };

  # Enable Hyprland
  programs.hyprland.enable = true;

  # Printing services and settings
  #services.printing.enable = true;
  #services.avahi = {
  #  enable = true;
  #  nssmdns4 = true;
  #  openFirewall = true;
  #};

  # Configure pipewire, the audio daemon
  #sound.enable = true;
  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Enable flatpak
  services.flatpak.enable = true;

  # Configure xdg desktop portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # My user and groups
  users.users.leonillo = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "leoNillo";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "games" "video" ];
    initialPassword = "Patataxd4";
  };

  # Permitir paquetes no libres
  nixpkgs.config.allowUnfree = true;

  # Steam, gamescope y gamemode
  programs = {
    steam = {
      enable = true;
      #remotePlay.openFirewall = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };

  # Java
  programs.java = {
    enable = true;
    package = pkgs.temurin-bin;
  };

  # Activar htop
  programs.htop.enable = true;

  # Activar firefox
  #programs.firefox.enable = true;

  # Activar git
  programs.git.enable = true;

  # QEMU/KVM + Virt Manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Virtualbox
  #virtualisation.virtualbox.host = {
  #  enable = true;
  #};

  # Waydroid
  #virtualisation.waydroid.enable = true;

  # Packages
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
    #brightnessctl
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
    #nur.repos.ataraxiasjel.waydroid-script
  ];

  # Automatic brightness control
  services.clight.enable = true;
  location = {
    latitude = 38.8911;
    longitude = 1.3969;
  };

  hardware.enableAllFirmware = true;

  # System fonts
  fonts = {
    packages = with pkgs; [
      #(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Meslo" ]; })
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
      hinting.enable = true;
      hinting.autohint = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
