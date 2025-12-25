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
  };
  programs.fish.enable = true;
  programs.direnv.enable = true;

  networking.firewall = {
    enable = true;
    extraCommands = ''
      # Flush previous custom rules to avoid duplicates on reload
      iptables -D OUTPUT -m owner --uid-owner agent -o lo -j ACCEPT 2>/dev/null || true
      iptables -D OUTPUT -m owner --uid-owner agent -j REJECT 2>/dev/null || true

      # Rule 1: Allow 'agent' to access the loopback interface (localhost)
      # This is required to reach the Squid proxy on 127.0.0.1:3128 and local DNS
      iptables -A OUTPUT -m owner --uid-owner agent -o lo -j ACCEPT

      # Rule 2: Reject all other outgoing traffic from 'agent'
      iptables -A OUTPUT -m owner --uid-owner agent -j REJECT
    '';
  };

  services.squid = {
    enable = true;
    extraConfig = ''
      # --- DOMAIN WHITELIST ---
      # Note: Leading dot includes subdomains (e.g., .anthropic.com includes api.anthropic.com)
      acl whitelist dstdomain .npmjs.org
      acl whitelist dstdomain .anthropic.com
      acl whitelist dstdomain .sentry.io
      acl whitelist dstdomain .pypi.org
      acl whitelist dstdomain .nixos.org
      acl whitelist dstdomain .claude.ai
      acl whitelist dstdomain .github.com
      acl whitelist dstdomain release-assets.githubusercontent.com
      acl whitelist dstdomain .cachix.org
      acl whitelist dstdomain storage.googleapis.com
      acl whitelist dstdomain files.pythonhosted.org

      http_access allow whitelist
      http_access deny all
      cache deny all

      shutdown_lifetime 1 seconds
    '';
  };

  environment.interactiveShellInit = ''
    if [ "$USER" = "agent" ]; then
      export http_proxy="http://127.0.0.1:3128"
      export https_proxy="http://127.0.0.1:3128"
      export HTTP_PROXY="http://127.0.0.1:3128"
      export HTTPS_PROXY="http://127.0.0.1:3128"
      # Ensure local services are not proxied
      export no_proxy="127.0.0.1,localhost,.localdomain"
      export NO_PROXY="127.0.0.1,localhost,.localdomain"
      export UV_LINK_MODE=copy
    fi
  '';

}
