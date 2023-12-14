{ pkgs, ... }:
{
  nix.settings.trusted-users = ["andreas"];
  nix.settings.max-jobs = 60;

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  services.nix-daemon.enable = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # https://www.stefanjudis.com/blog/why-i-dont-need-to-clean-up-my-desktop-and-downloads-folder-in-macos/
  system.defaults.screencapture.location = "/private/tmp";
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3; # Use keyboard navigation to move focus between controls

  security.pam.enableSudoTouchIdAuth = true;
  users.users.andreas.home = "/Users/andreas";

  fonts = {
      fontDir.enable = true;
      fonts = [
          pkgs.fira-code
      ];
  };

}
