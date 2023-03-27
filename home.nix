{ config, pkgs, lib, ... }:

{
  home.stateVersion = "23.05";

  programs.direnv.enable = true;
  programs.htop.enable = true;
  programs.git = {
      enable = true;
      userName = "Andreas Pelme";
      userEmail = "andreas@pelme.se";
      aliases = {
          done = "!branch=$(git rev-parse --abbrev-ref HEAD); git switch main && git branch -D $branch";
      };

      extraConfig = {
          commit.template = "${./git_commit_template.txt}";

          push.autosetupremote = true;
          push.default = "current";

          pull.rebase = true;

          diff.noprefix = true;
          init.defaultBranch = "main";
          branch.sort = "-committerdate";

          # delta
          core.pager = "${pkgs.delta}/bin/delta";
          interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
          delta.navigate = true;
          delta.light = false;
          merge.conflictstyle = "diff3";
          diff.colorMoved = "default";
      };

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

  home.shellAliases = {
      code = "/usr/local/bin/code";
      pbclean = "pbpaste | pbcopy";
  };
  home.packages = with pkgs; [
      aws-vault
      awscli2
      coreutils
      curl
      jq
      python311
      ripgrep
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
