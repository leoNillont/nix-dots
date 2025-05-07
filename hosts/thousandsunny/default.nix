{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./disko-config.nix
  ];

  # Hardware configuration, this desktop has an AMD GPU
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
  services.xserver.videoDrivers = [ "amdgpu" ];

  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
    "amd_pstate=active"
  ];

  # Hostname, this is used so I don't have to use --flake on rebuild
  networking.hostName = "thousandsunny";

  powerManagement.powertop.enable = lib.mkForce false; # Disable powertop due to USB issues

  services = {
    #fwupd.enable = true; # Firmware updates, not in use right now
    clight.enable = lib.mkForce false; # Disable clight (not needed on desktop)
    power-profiles-daemon.enable = lib.mkForce false; # Conflicts with LACT, too lazy to fix
  };

  fileSystems = {
    # Disk was used for other purpose, commented for now
    # "/media/DiscoExtra" = {
    #   device = "/dev/disk/by-uuid/36cab7e8-94ae-4fa3-9147-19192df6c874";
    #   fsType = "btrfs";
    #   options = [ "noatime" "space_cache=v2" "compress=zstd" "ssd" ];
    # };

    "/media/NAS" = {
      device = "192.168.1.96:/Datos";
      fsType = "nfs";
      options = [
        "defaults"
        "user"
        "noatime"
        "x-systemd.automount"
        "noauto"
        "x-systemd.device-timeout=5"
        "x-systemd.idle-timeout=60"
        "bg"
        "soft"
        "timeo=5"
        "retrans=2"
        "_netdev"
        "async"
        "rsize=32768"
        "wsize=32768"
      ];
    };
  };

  networking = {
    interfaces.enp38s0.ipv4.addresses = [
      {
        address = "192.168.1.69";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.10" ];
    firewall.allowedTCPPorts = [ 25565 ]; # Allow Minecraft server port in case I want to host
    networkmanager.dns = "systemd-resolved";
  };

  # Install LACT and start on boot
  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };
  environment.systemPackages = with pkgs; [ lact ];
}
