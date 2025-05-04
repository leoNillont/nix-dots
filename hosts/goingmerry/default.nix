{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # Hardware Configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        mesa.opencl
        vaapiVdpau
        libvdpau-va-gl
        vulkan-loader
        vulkan-validation-layers
        libva
        libva-utils
        rocmPackages.clr.icd
        rocmPackages.rocminfo
        rocmPackages.rocm-smi
      ];
    };
    amdgpu.opencl.enable = true;
    bluetooth.enable = true;
  };

  # Kernel Parameters
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];


  services = {
    xserver.videoDrivers = [ "amdgpu" ];
    #mysql = {
    #  enable = true;
    #  package = pkgs.mariadb;
    #};
    power-profiles-daemon.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    logind.extraConfig = ''HandlePowerKey=ignore'';
  };

  environment.systemPackages = [ pkgs.framework-tool ];

  # Hostname Configuration, used so I don't have to use --flake on rebuild
  networking.hostName = "goingmerry";
}
