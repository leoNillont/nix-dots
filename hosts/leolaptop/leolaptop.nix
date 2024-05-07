{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Drivers de la GPU Intel
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vulkan-loader
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  
  # Drivers de la GPU Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  # Desactivar boton de apagado (Joel Disabler)
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
  '';

  # Hostname
  networking.hostName = "leolaptop";
}
