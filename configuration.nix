# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


{
  # Use latest linux kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Flakes and Nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    #themePackages = "catppuccin";
    #theme = "catppuccin";
  };
  boot.kernelParams = [ "quiet" "loglevel=3" "rd.udev.log_level=3" "systemd.show_status=auto" ];

  # Zram
  zramSwap.enable = true;

  # CPU governor
  powerManagement.cpuFreqGovernor = "ondemand";

  # Fish shell
  programs.fish.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Flatpak
  services.flatpak.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      vulkan-loader #sin esto no abre VulkanMod
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";

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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Keymaps
    xkb = {
      layout = "us";
      variant = "colemak";
    };

    # Enable SDDM
    displayManager.sddm.enable = true;
  };

  # Enable plasma
  services.desktopManager.plasma6.enable = true;

  # Enable the Hyprland tiling compositor
  #programs.hyprland.enable = true;

  console.keyMap = "colemak";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leonillo = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Noel";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    #packages = with pkgs; [
    #];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Steam
  programs.steam.enable = true;

  # Mullvad
  #services.mullvad-vpn.enable = true;
  # Syncthing
  #services.syncthing = {
  #  enable = true;
  #};

  # QEMU/KVM + Virt Manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Virtualbox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "leonillo" ];

  # Disable power button (Joel Disabler)
  #services.logind.extraConfig = ''
  #  HandlePowerKey=ignore
  #'';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    vulkan-tools
    neovim
    wget
    curl
    btop
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 25565 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
