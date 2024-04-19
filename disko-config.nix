{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; 
                subvolumes = {
                  "@" = {
                    mountOptions = [ "noatime" "compress=zstd:2" "space_cache=v2" ];
                    mountpoint = "/";
                  };
                  "@home" = {
                    mountOptions = [ "noatime" "compress=zstd:2" "space_cache=v2" ];
                    mountpoint = "/home";
                  };
                  "@nix" = {
                    mountOptions = [ "noatime" "compress=zstd:2" "space_cache=v2" ];
                    mountpoint = "/nix";
                  };
                  "@swap" = {
                    mountpoint = "/.swap";
                    swap = {
                      swapfile.size = "8G";
                    };
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "noatime" "compress=zstd:2" "space_cache=v2" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

