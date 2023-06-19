{ pkgs, lib, ... }:
{
  nix.settings.trusted-users = ["andreas"];
  nix.settings.max-jobs = 30;

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  services.nix-daemon.enable = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3; # Use keyboard navigation to move focus between controls

  security.pam.enableSudoTouchIdAuth = true;

  fonts = {
      fontDir.enable = true;
      fonts = [
          pkgs.fira-code
      ];
  };

}
