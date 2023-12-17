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
  system.defaults = {
      screencapture.location = "/private/tmp";
      trackpad = {
          Clicking = true;

      };
      dock = {
          autohide = true;
          tilesize = 45;
          largesize = 55;
          magnification = true;
          wvous-tl-corner = 5; # screensaver
          wvous-tr-corner = 2; # mission control
          wvous-br-corner = 4; # desktop
          show-recents = false;
      };
      NSGlobalDomain = {
          InitialKeyRepeat = 15; # FA
          KeyRepeat = 2; # ST!!
          ApplePressAndHoldEnabled = false; # avoid showing accents etc
          AppleKeyboardUIMode = 3; # Use keyboard navigation to move focus between controls
      };
      CustomUserPreferences = {
          "com.apple.mail".DisableInlineAttachmentViewing = true;
          "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
        };
      };
  };


  security.pam.enableSudoTouchIdAuth = true;

  users.users.andreas.home = "/Users/andreas";

  environment.shells = [ "/etc/profiles/per-user/andreas/bin/fish" ];

  fonts = {
      fontDir.enable = true;
      fonts = [
          pkgs.fira-code
      ];
  };

  system.activationScripts.postUserActivation.text = ''
    killall Dock
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

}
