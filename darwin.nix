{ pkgs, ... }:
{
  imports = [
    ./modules/nix.nix
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 5;

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
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.andreas.home = "/Users/andreas";

  fonts.packages = [
    pkgs.fira-code
    pkgs.nerd-fonts.fira-code
  ];

  system.activationScripts.postUserActivation.text = ''
    killall Dock
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    ANDREAS_FISH="/etc/profiles/per-user/andreas/bin/fish"
    grep -q "$ANDREAS_FISH" /etc/shells || echo "$ANDREAS_FISH" | sudo tee -a /etc/shells
  '';
}
