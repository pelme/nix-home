{ ... }:
{
  boot.initrd.luks.devices = {
    "luks-61ce37dd-a5ed-4177-ab7c-494482e1cdc5".device = "/dev/nvme0n1p2";
  };

  swapDevices = [
    {
      device = "/dev/nvme0n1p3";
      randomEncryption = true;
    }
  ];

  networking.hostName = "snowdrop";

  boot.initrd.availableKernelModules = [ "nvme" ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-61ce37dd-a5ed-4177-ab7c-494482e1cdc5";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4188-6523";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

}
