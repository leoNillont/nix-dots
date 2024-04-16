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
      #themePackages = "catppuccin";
      #theme = "catppuccin";
    };
    kernelParams = [ "quiet" "loglevel=3" "rd.udev.log_level=3" "systemd.show_status=auto" ];
  };

  # Activar kernel linux-zen
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Activar Zram
  zramSwap.enable = true;

  # Governador de CPU
  powerManagement.cpuFreqGovernor = "ondemand";

  # Activar la shell Fish
  programs.fish.enable = true;

  # Activar NetworkManager
  networking.networkmanager.enable = true;

  # Zona horaria
  time.timeZone = "Europe/Madrid";

  # Idioma
  i18n.defaultLocale = "es_ES.UTF-8";

  # Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Locales 
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
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

  # Activar SDDM
  services.displayManager.sddm.enable = true;

  # Activar Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Activar Hyprland
  programs.hyprland.enable = true;

  # Activar cups (impresora)
  #services.printing.enable = true;

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

  # Paquetes globales
  environment.systemPackages = with pkgs; [
    vulkan-tools
    neovim
    wget
    curl
    btop
    htop
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
