{ inputs, ... }:
{
  # Declarative description of the nvme layout, for reinstalls via the disko
  # CLI or nixos-anywhere. disko.enableConfig = false means it generates no
  # fileSystems/swapDevices at eval time — hardware-configuration.nix stays
  # authoritative for the running system, and `nh os switch` behavior is
  # unchanged. The ntfs data disks (sda/sdb) are deliberately not managed by
  # disko so a reinstall can never format them.
  flake.nixosModules.disko = _: {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.enableConfig = false;

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            priority = 1;
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0022"
                "dmask=0022"
              ];
            };
          };
          swap = {
            priority = 2;
            size = "20G";
            content.type = "swap";
          };
          root = {
            priority = 3;
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
