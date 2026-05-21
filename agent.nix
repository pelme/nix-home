{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5QIGg2nhvXy4PY2Orhb5cG//7xZUBxbtS7nvpol7Az andreas@flax"
  ];
in
{
  system.stateVersion = "25.05";

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_scsi"
    "xhci_pci"
    "usbhid"
    "sr_mod"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-linux";
  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "agent";
        ensureClauses.superuser = true;
      }
    ];
    ensureDatabases = [ "agent" ];
  };

  virtualisation.virtualbox.guest.enable = true;
  time.timeZone = "Europe/Stockholm";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fileSystems."/home/agent/share" = {
    device = "agent-share";
    fsType = "vboxsf";
    options = [
      "rw"
      "uid=${toString config.users.users.agent.uid}"
      "gid=${toString config.users.groups.users.gid}"
    ];
  };
  systemd.tmpfiles.rules = [
    "d /home/agent/share 0755 agent users -"
  ];
  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    htop
    neovim
    helix
    claude-code
    git
    ripgrep
    uv
    python313
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default;

  networking.hostName = "agent";
  networking.useDHCP = true;
  networking.useNetworkd = true;
  networking.interfaces.enp0s9.useDHCP = false;
  networking.interfaces.enp0s9.ipv4.addresses = [
    {
      address = "192.168.78.10";
      prefixLength = 24;
    }
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = sshKeys;
  users.users.agent.openssh.authorizedKeys.keys = sshKeys;

  users.users.agent = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.fish;
    uid = 1000;
    extraGroups = [ "docker" ];
  };
  programs.fish.enable = true;
  programs.direnv.enable = true;
}
