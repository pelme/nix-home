{ pkgs, ... }: {
  programs.steam.enable = true;
  programs.chromium.enable = true;
  environment.systemPackages = with pkgs; [
    slack
    spotify
    thunderbird
    _1password-gui
    zed-editor
    obsidian
  ];
}
