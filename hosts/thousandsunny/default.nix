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
        rocmPackages.clr
        rocmPackages.clr.icd
        rocmPackages.rocminfo
        rocmPackages.rocm-smi
        rocmPackages.rocblas
        rocmPackages.hipblas
      ];
    };
    bluetooth.enable = true;
    amdgpu.initrd.enable = true;
  };
  services.xserver.videoDrivers = [ "modesetting" ];

  boot = {
    kernelParams = [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amd_pstate=active"
    ];
    supportedFilesystems = [ "nfs" ];
  };

  # Hostname, this is used so I don't have to use --flake on rebuild
  networking.hostName = "thousandsunny";

  powerManagement = {
    powertop.enable = lib.mkForce false; # Disable powertop due to USB issues
    cpuFreqGovernor = "performance";
  };

  services = {
    fwupd.enable = true; 
    clight.enable = lib.mkForce false; # Disable clight (not needed on desktop)
    power-profiles-daemon.enable = lib.mkForce false; # Conflicts with LACT, too lazy to fix
  };

  fileSystems = {
    "/media/DiscoExtra" = {
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_50026B7381CEE10E-part2";
      fsType = "ntfs";
    };
  };
    
  #};
  services.rpcbind.enable = true; # needed for nfs
  systemd = {
    mounts = [{
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "192.168.1.96:/Datos";
      where = "/media/NAS";
    }];
    automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/media/NAS";
    }];
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
  environment.systemPackages = with pkgs; [ lact davinci-resolve ]; # also added resolve here because I only need it on this computer

  # HIP/ROCM workaround
  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];
}
