{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # Drivers de la GPU AMD
  hardware.graphics = {
    enable = true;
    #driSupport = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      #rocmPackages.clr.icd
      vaapiVdpau
      libvdpau-va-gl
      vulkan-loader
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  #boot.kernelParams = [ "amd_pstate=active" ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    #powerOnBoot = false;
  };
  
  # MySQL para las practicas
  #services.mysql = {
  #  enable = true;
  #  package = pkgs.mariadb;
  #};

  # TLP
  #services.tlp = {
  #  enable = true;
  #  settings = {
  #    CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
  #    CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
  #
  #    #CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
  #    #CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #
  #    #CPU_MIN_PERF_ON_AC = 0;
  #    #CPU_MAX_PERF_ON_AC = 100;
  #    #CPU_MIN_PERF_ON_BAT = 0;
  #    #CPU_MAX_PERF_ON_BAT = 100;
  #
  #  };
  #};

  # Power Profiles Daemon
  services.power-profiles-daemon.enable = true;
  
  # Lector de huellas
  services.fprintd.enable = true;
  #security.pam.services.swaylock.fprintAuth = true;
  #security.pam.services.sddm.fprintAuth = true;

  # Desactivar boton de apagado (Joel Disabler)
  #services.logind.extraConfig = ''
  #  HandlePowerKey=ignore
  #'';

  # Hostname
  networking.hostName = "leoframework";
}
