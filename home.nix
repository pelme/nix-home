{ config, pkgs, lib, ... }:

{
  home.stateVersion = "23.05";

  programs.direnv.enable = true;
  programs.htop.enable = true;
  programs.git = {
      enable = true;
  };

  programs.fish = {
      enable = true;

      loginShellInit = ''
          # This is needed to workaround the PATH being set in the wrong order.
          # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1030877541
          fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

          set -g fish_greeting
      '';
      interactiveShellInit = (builtins.readFile ./fish/prompt.fish ) + (builtins.readFile ./fish/abbr.fish);
  };
  programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
          vim-airline
          vim-airline-themes
          vim-commentary
          vim-nix
          vim-one
          vim-surround
          vim-fish
          ctrlp-vim
      ];
      extraConfig = builtins.readFile ./vimrc.vim;
  };

  home.packages = with pkgs; [
      awscli2
      coreutils
      curl
      jq
      ripgrep
      python311
      rsync
      s3cmd
      socat
      tmux
      wget
      yubikey-manager
  ];

  home.file = {
      ".hushlogin".text = "";
      ".psqlrc".text = ''
          \set QUIET ON
          \pset null 'NULL'
          \timing
          \set COMP_KEYWORD_CASE upper
          \set QUIET OFF
      '';

  };

  home.sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      PYTHONIOENCODING = "UTF-8";
  };

}
