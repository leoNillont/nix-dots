{ pkgs, lib, ... }:

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
        #mesa.opencl
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
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
  # environment.variables = {
  #   RUSTICL_ENABLE = "radeonsi";
  # };

  # Fixes a bug that causes lots and lots of lag
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x0"
    "amd_pstate=active"
    "pcie_aspm=force"
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      pkiBundle = "/var/lib/sbctl";
      enable = true;
      autoGenerateKeys = true;
      autoEnrollKeys.enable = true;
    };
  };

  services = {
    tuned.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    scx = {
      enable = true;
      scheduler = "scx_lavd";
      extraArgs = [ "--autopower" ];
    };
  };
  location = {
    latitude = 38.8977;
    longitude = 1.4022;
  };

  environment.systemPackages = with pkgs; [
    framework-tool
    clight-gui
  ];

  # Hostname Configuration, used so I don't have to use --flake on rebuild
  networking.hostName = "goingmerry";
}
