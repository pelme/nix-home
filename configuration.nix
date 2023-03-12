{ pkgs, lib, ... }:
{
  nix.settings.trusted-users = ["andreas"];

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  services.nix-daemon.enable = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3; # Use keyboard navigation to move focus between controls

  security.pam.enableSudoTouchIdAuth = true;

  homebrew.enable = true;
  homebrew.brewPrefix = "/usr/local/bin";
  homebrew.casks = [
      "1password"
      "arq"
      "chromedriver"
      "discord"
      "firefox"
      "google-chrome"
      "google-drive"
      "istat-menus"
      "iterm2"
      "microsoft-teams"
      "poedit"
      "postico"
      "slack"
      "spotify"
      "teamviewer"
      "visual-studio-code"
      "yubico-authenticator"
      "yubico-yubikey-manager"
      "zoom"
      "sloth"
  ];

  homebrew.masApps = {
      "BetterSnapTool" = 417375580;
      "ColorSlurp" = 1287239339;
      "Be Focused Pro - Focus Timer" = 961632517;
      "Messenger" = 1480068668;
      "Microsoft Word" = 462054704;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      "Xcode" = 497799835;
  };

  fonts = {
      fontDir.enable = true;
      fonts = [
          pkgs.fira-code
      ];
  };

}
