{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./disko-config.nix
    ./resolve.nix
  ];

  # Hardware configuration, this desktop has an AMD GPU
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
    bluetooth.enable = true;
    amdgpu = {
      initrd.enable = true;
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
  };

  environment.variables = {
    RUSTICL_ENABLE = "radeonsi";
  };

  boot = {
    kernelParams = [
      "amd_pstate=active"
    ];
    supportedFilesystems = [ "nfs" ];
    tmp.useTmpfs = lib.mkForce false;
    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
  };

  powerManagement = {
    powertop.enable = lib.mkForce false; # Disable powertop due to USB issues
    cpuFreqGovernor = "performance";
  };

  services = {
    #fwupd.enable = true; 
    clight.enable = lib.mkForce false; # Disable clight (not needed on desktop)
    power-profiles-daemon.enable = lib.mkForce false; # Conflicts with LACT, too lazy to fix
    rpcbind.enable = true; # needed for nfs
    xserver.videoDrivers = [ "modesetting" ];
    resolved.dnssec = lib.mkForce "true";
  };

  fileSystems = {
    "/media/DiscoExtra" = {
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_50026B7381CEE10E-part2";
      fsType = "ntfs";
    };
  };
    
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
    # Setup lact and lactd
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = [ "multi-user.target" ];
  };

  networking = {
    interfaces.enp38s0.ipv4.addresses = [
      {
        address = "192.168.1.69";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.1";
    nameservers = [ "9.9.9.9" ];
    firewall.allowedTCPPorts = [ 25565 ]; # Allow Minecraft server port in case I want to host
    networkmanager.enable = lib.mkForce false;
    hostName = "thousandsunny"; # with this I don't have to use --flake on rebuild
  };

  environment.systemPackages = with pkgs; [ 
    lact 
    nvtopPackages.amd 
    #davinci-resolve
  ];
}
