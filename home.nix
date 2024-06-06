{
  pkgs,
  lib,
  ...
}: {
  home.stateVersion = "23.11";

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
      rerere.enabled = true;
      commit.template = "${./git_commit_template.txt}";

      push.autosetupremote = true;
      push.default = "current";

      pull.rebase = true;

      diff.noprefix = true;
      init.defaultBranch = "main";
      branch.sort = "-committerdate";

      advice.skippedCherryPicks = false;

      diff.colorMoved = "default";
    };
  };

  programs.sapling = {
    enable = true;
    userName = "Andreas Pelme";
    userEmail = "andreas@pelme.se";
  };

  programs.fish = {
    enable = true;

    loginShellInit = ''
      # This is needed to workaround the PATH being set in the wrong order.
      # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1030877541
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

      set -g fish_greeting
      set __done_min_cmd_duration 2000
    '';
    interactiveShellInit = lib.concatStringsSep "\n" (map builtins.readFile [
      ./fish/prompt.fish
      ./fish/abbr.fish
      ./fish/homebrew.fish
      (pkgs.fetchurl {
        url = "https://iterm2.com/shell_integration/fish";
        hash = "sha256-tdn4z0tIc0nC5nApGwT7GYbiY91OTA4hNXZDDQ6g9qU=";
      })
    ]);
    plugins = with pkgs.fishPlugins; [
      {
        name = "done";
        src = done.src;
      }
      #{name = "grc"; src = grc.src;}
    ];
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "molokai";
      editor = {
        bufferline = "multiple";
        color-modes = true;
        file-picker.hidden = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
      keys.normal = {
        "{" = ["goto_prev_paragraph"];
        "}" = ["goto_next_paragraph"];
      };
    };
    languages = {
      language-server.pylsp.config.pylsp = {
        plugins.black.enabled = true;
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
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
    pbclean = "pbpaste | pbcopy";
  };
  home.packages = with pkgs; [
    _1password
    alejandra
    awscli2
    bashInteractive
    cachix
    comma
    coreutils
    curl
    gh
    grc
    httpie
    jq
    jujutsu
    nodePackages.npm
    nodejs
    openssh
    poetry
    ripgrep
    rsync
    s3cmd
    socat
    sops
    tailscale
    tmux
    wget
    (pkgs.runCommand "all-the-pythons" {} ''
      mkdir -p $out/bin
      ln -s ${pkgs.python312}/bin/python $out/bin/python3
      ln -s ${pkgs.python312}/bin/python $out/bin/python

      ln -s ${pkgs.python39}/bin/python $out/bin/python3.9
      ln -s ${pkgs.python310}/bin/python $out/bin/python3.10
      ln -s ${pkgs.python311}/bin/python $out/bin/python3.11
      ln -s ${pkgs.python312}/bin/python $out/bin/python3.12
      ln -s ${pkgs.python313}/bin/python $out/bin/python3.13
    '')
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
