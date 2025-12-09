{ disks ? [ "/dev/disk/by-id/nvme-Sabrent_Rocket_Q4_48816081704093" ], ... }:
{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";  # EFI system partition
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nofail" "umask=0077" ];
              };
            };

            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "Data";  # <- zpool name
              };
            };
          };
        };
      };
    };

    zpool = {
      Data = {
        type = "zpool";

        # default properties for all datasets in this pool
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          atime = "off";
          xattr = "sa";
          acltype = "posixacl";
          "com.sun:auto-snapshot" = "true";
        };


        # general zpool options (tweak to taste)
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          # This becomes Data/System → /  (root)
          System = {
            type = "zfs_fs";
            mountpoint = "/";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
            };
          };

          Nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "/nix";
          };

          # This becomes Data/Home → /home
          Home = {
            type = "zfs_fs";
            mountpoint = "/home";
          };
        };
      };
    };
  };
}
