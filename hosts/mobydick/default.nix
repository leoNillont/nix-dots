{ config, pkgs, lib, ... }:

{
  # Import hardware configuration
  imports = [
    ./hardware.nix
  ];

  # Hardware Configuration
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vulkan-loader
        libvdpau-va-gl
      ];
    };

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    thermald.enable = true;

    power-profiles-daemon.enable = true;

    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  # Hostname Configuration, used so I don't have to use --flake on rebuild
  networking.hostName = "mobydick";
}
