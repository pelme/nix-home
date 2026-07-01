{ lib, ... }: {

  services.xserver.xkb = {
    layout = "se,us";
    options = "grp:ctrl_space_toggle";
    variant = "";
  };
  console.keyMap = "sv-latin1";

  services.printing.enable = true;
  services.libinput.touchpad.naturalScrolling = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.fprintd.enable = true;
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

  networking = {
    useNetworkd = true;
    networkmanager.enable = true;
  };
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  programs.firefox.enable = true;

  # Run LSPs provided by Zed:
  # https://wiki.nixos.org/wiki/Zed#Nix-ld_(recommended)
  # Also useful to run binary wheels with uv
  programs.nix-ld.enable = true;
}
