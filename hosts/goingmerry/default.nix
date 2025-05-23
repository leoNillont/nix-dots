{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./disko-config.nix
  ];

  # Hardware Configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-loader
        libva
        libva-utils
        rocmPackages.clr.icd
        rocmPackages.rocminfo
        rocmPackages.rocm-smi
      ];
    };
    bluetooth.enable = true;
  };
  services.xserver.videoDrivers = [ "modesetting" ];

  # Kernel Parameters
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];


  services = {
    power-profiles-daemon.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
  };

  environment.systemPackages = [ pkgs.framework-tool ];

  # Hostname Configuration, used so I don't have to use --flake on rebuild
  networking.hostName = "goingmerry";
}
