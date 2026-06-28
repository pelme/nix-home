{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
  ];

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

  users.users.andreas = {
    isNormalUser = true;
    description = "Andreas Pelme";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  programs.steam.enable = true;
  programs.chromium.enable = true;
  environment.systemPackages = with pkgs; [
    sbctl
    slack
    spotify
    thunderbird
    _1password-gui
    zed-editor
  ];

  services.openssh.enable = true;
  services.fprintd.enable = true;

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
