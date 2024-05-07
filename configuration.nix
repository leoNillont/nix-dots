{ config, pkgs, ... }:


{
  # Activar flakes y nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader y Plymouth
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.enable = true;
  
    plymouth = {
      enable = true;
      themePackages = [ (pkgs.catppuccin-plymouth.override { variant = "mocha"; }) ];
      theme = "catppuccin-mocha";
    };
    kernelParams = [ "quiet" "loglevel=3" "rd.udev.log_level=3" "systemd.show_status=auto" ];
  };

  # Activar kernel linux-zen
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Activar Zram
  zramSwap.enable = true;

  # Governador de CPU
  powerManagement.cpuFreqGovernor = "ondemand";

  # Mullvad VPN
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Thunar
  programs.thunar = {
    enable = true;
    plugins = [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
      ffmpegthumbnailer
    ];
  };
  services.tumbler.enable = true;

  # Activar la shell Fish
  programs.fish.enable = true;

  # Activar NetworkManager
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;

  # Systemd-resolved
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };

  # Zona horaria
  time.timeZone = "Europe/Madrid";

  # Idioma
  i18n.defaultLocale = "en_US.UTF-8";

  # Wayland
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

  # Activar keymap fuera de X
  console.keyMap = "colemak";

  # Activar y configurar X
  services.xserver = {
    enable = true;

    # Keymaps
    xkb = {
      layout = "us";
      variant = "colemak";
    };
  };

  # GVFS pal pcmanfm
  services.gvfs.enable = true;

  # Fixeo pal swaylock
  security.pam.services.swaylock = {};

  # Activar SDDM
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "catppuccin-mocha";
    wayland.enable = true;
  };

  # Activar Plasma 6
  #services.desktopManager.plasma6.enable = true;

  # Activar Hyprland
  programs.hyprland.enable = true;

  # Activar cups (impresora)
  #services.printing.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "leonillo";
    dataDir = "/home/leonillo/Syncthings";
    configDir = "/home/leonillo/Syncthings/.config/syncthing";
  };

  # Activar y configurar pipewire (sonido)
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Activar Flatpak
  services.flatpak.enable = true;

  # Crear mi usuario
  users.users.leonillo = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Noel";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };

  # Permitir paquetes no libres
  nixpkgs.config.allowUnfree = true;

  # Steam
  programs.steam.enable = true;

  # QEMU/KVM + Virt Manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Docker
  #virtualisation.docker = { 
  #  enable = true;
  #  storageDriver = "btrfs";
  #};

  # MySQL (para las practicas)
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };


  # Paquetes globales
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
    unrar-free
    brightnessctl
    ranger
    (callPackage ./custompkgs/catppuccin-sddm.nix {})
    (catppuccin-kvantum.override { accent = "Mauve"; variant = "Mocha"; })
  ];

  # Fuentes
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Meslo" ]; })
    font-awesome
    meslo-lgs-nf
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
