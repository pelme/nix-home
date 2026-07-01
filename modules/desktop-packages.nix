{ pkgs, ... }: {
  programs.steam.enable = true;
  programs.chromium.enable = true;
  environment.systemPackages = with pkgs; [
    _1password-gui
    chromium
    discord
    obsidian
    slack
    spotify
    yubioath-flutter
    zed-editor
  ];
  # make yubikey's work with one time codes
  services.pcscd.enable = true;
}
