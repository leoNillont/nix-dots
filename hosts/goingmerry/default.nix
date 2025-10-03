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
        mesa.opencl
      ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    framework = {
      enableKmod = false;
      laptop13 = {
        audioEnhancement = {
          enable = true;
          hideRawDevice = false;
        };
      };
    };
    amdgpu = {
      initrd.enable = true;
    };
  };
  services.xserver.videoDrivers = [ "modesetting" ];
  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  # Fixes a bug that causes lots and lots of lag
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];


  services = {
    power-profiles-daemon.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
  };

  #environment.systemPackages = with pkgs; [ framework-tool wluma ]; #TODO make wluma declarative
  
  # Hostname Configuration, used so I don't have to use --flake on rebuild
  networking.hostName = "goingmerry";
}
