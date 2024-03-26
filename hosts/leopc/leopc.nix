{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # AMD Drivers
  hardware.opengl = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  # Hip workaround
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # Hostname
  networking.hostName = "leopc";

  # Disco Extra
  fileSystems."/media/DiscoExtra" =
    { device = "/dev/disk/by-uuid/36cab7e8-94ae-4fa3-9147-19192df6c874";
      fsType = "btrfs";
    };
  
  # NAS
  fileSystems."/media/NAS" = {
    device = "192.168.1.96:/Datos";
    fsType = "nfs";
  };

}
