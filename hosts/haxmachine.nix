{
  pkgs,
  ...
}:
let
  constants = import ../constants.nix;
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-partlabel/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C2FA-4808";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/fac1ee8b-2871-41f5-93a3-9f7d40a45271"; }
  ];

  networking.hostName = "haxmachine";

  users.users.tilde = {
    isNormalUser = true;
    description = "tilde";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    firefox
    vscode
    git
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = constants.sshKeys;
  users.users.tilde.openssh.authorizedKeys.keys = constants.sshKeys;
}
