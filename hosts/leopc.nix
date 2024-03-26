{ config, pkgs, ... }:

{
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
}
