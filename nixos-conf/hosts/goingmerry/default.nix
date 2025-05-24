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
        #rocmPackages.rocminfo
        #rocmPackages.rocm-smi
      ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    framework = {
      enableKmod = true;
      laptop13 = {
        audioEnhancement = {
          enable = true;
          hideRawDevice = false;
        };
      };
    };
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
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.stdenv.shell} -c 'chgrp video /sys/class/backlight/%k/brightness'"
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.stdenv.shell} -c 'chmod g+w /sys/class/backlight/%k/brightness'"
      ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.stdenv.shell} -c 'chgrp video /sys/class/leds/%k/brightness'"
      ACTION=="add", SUBSYSTEM=="leds", RUN+="${pkgs.stdenv.shell} -c 'chmod g+w /sys/class/leds/%k/brightness'"
    '';
  };

  environment.systemPackages = with pkgs; [ framework-tool wluma ]; #TODO make wluma declarative
  
  # Hostname Configuration, used so I don't have to use --flake on rebuild
  networking.hostName = "goingmerry";
}
