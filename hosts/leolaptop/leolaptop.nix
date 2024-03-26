{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];
  # Intel Drivers
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    vaapiIntel
  ];
  
  # Nvidia Drivers
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
