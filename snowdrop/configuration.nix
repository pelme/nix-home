{ pkgs, ... }:

{
  imports = [
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    "luks-61ce37dd-a5ed-4177-ab7c-494482e1cdc5".device = "/dev/nvme0n1p2";
  };

  swapDevices = [
    {
      device = "/dev/nvme0n1p3";
      randomEncryption = true;
    }
  ];
  networking.hostName = "snowdrop"; # Define your hostname.

  networking = {
    useNetworkd = true;
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Stockholm";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "se,us";
    options = "grp:ctrl_space_toggle";
    variant = "";
  };
  console.keyMap = "sv-latin1";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  users.users.andreas = {
    isNormalUser = true;
    description = "Andreas Pelme";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      thunderbird
      _1password-gui
      zed-editor
    ];
  };


  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.chromium.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    slack
    spotify
  ];

  services.openssh.enable = true;
  services.fprintd.enable = true;

  programs.fish.enable = true;
  system.stateVersion = "25.11";
}
