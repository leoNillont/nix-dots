{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # AMD Drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      #rocmPackages.clr.icd
      vaapiVdpau
      libvdpau-va-gl
      vulkan-loader
      #rocmPackages.rocminfo
      #rocmPackages.rocm-smi
    ];
  };
  hardware.amdgpu.opencl.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    #powerOnBoot = true;
  };

  # Hip workaround
  #systemd.tmpfiles.rules = 
  #let
  #  rocmEnv = pkgs.symlinkJoin {
  #    name = "rocm-combined";
  #    paths = with pkgs.rocmPackages; [
  #      rocblas
  #      hipblas
  #      clr
  #    ];
  #  };
  #in [
  #  "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  #];

  # Corectrl
  #programs.corectrl = {
  #  enable = true;
  #  gpuOverclock.enable = true;
  #};
  #security.polkit.extraConfig = ''
  #  polkit.addRule(function(action, subject) {
  #    if ((action.id == "org.corectrl.helper.init" ||
  #       action.id == "org.corectrl.helperkiller.init") &&
  #      subject.local == true &&
  #      subject.active == true &&
  #      subject.isInGroup("wheel")) {
  #          return polkit.Result.YES;
  #    }
  #  });
  #'';

  #boot.kernelParams = [ "amd_pstate=active" ];
  #powerManagement.cpuFreqGovernor = "schedutil";
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" "amd_pstate=guided"];

  # Hostname
  networking.hostName = "thousandsunny";

  # Power profiles daemon
  #services.power-profiles-daemon.enable = true;
  
  services.fwupd.enable = true;

  # Disco Extra
  #fileSystems."/media/DiscoExtra" =
  #  { device = "/dev/disk/by-uuid/36cab7e8-94ae-4fa3-9147-19192df6c874";
  #    fsType = "btrfs";
  #    options = [ "noatime" "space_cache=v2" "compress=zstd" "ssd" ];
  #  };
  
  # NAS
  fileSystems."/media/NAS" = {
    device = "192.168.1.96:/Datos";
    fsType = "nfs";
    options = [ "defaults" "x-systemd.automount" "noauto" "x-systemd.device-timeout=5" "retrans=5" "_netdev" ];
  };

  # Disable powertop because of issues with USB
  powerManagement.powertop.enable = lib.mkForce false;

  # Not needed on desktop
  services.clight.enable = lib.mkForce false;

  # NAS, but with systemd
  #services.rpcbind.enable = true; # needed for NFS
  #systemd.mounts = [{
  #  type = "nfs";
  #  mountConfig = {
  #    Options = [ "noatime" ];
  #  };
  #  what = "192.168.1.96:/Datos";
  #  where = "/media/NAS";
  #}];
  #
  #systemd.automounts = [{
  #  wantedBy = [ "multi-user.target" ];
  #  automountConfig = {
  #    TimeoutIdleSec = "600";
  #  };
  #  where = "/media/NAS";
  #}];

  environment.systemPackages = with pkgs; [ lact ];
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  # IP Estatica
  networking = {
    interfaces = {
      enp38s0.ipv4.addresses = [ {
       address = "192.168.1.69";
       prefixLength = 24;
      } ];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.10" ];
    firewall.allowedTCPPorts = [ 25565 ];
  };
  networking.networkmanager.dns = "systemd-resolved";

}
