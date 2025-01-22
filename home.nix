{
  pkgs,
  lib,
  ...
}:
{
  home.stateVersion = "23.11";

  programs.direnv.enable = true;
  programs.htop.enable = true;
  programs.fzf.enable = true;
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
      rebase.updateRefs = true;

      diff.noprefix = true;
      init.defaultBranch = "main";
      branch.sort = "-committerdate";

      advice.skippedCherryPicks = false;
      advice.detachedHead = false;

      diff.colorMoved = "default";
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "andreas@pelme.se";
        name = "Andreas Pelme";
      };
      diff.format = "git";
      ui.default-command = "log";
      ui.merge-editor = "vscode";
      ui.conflict-marker-style = "git";
      ui.default-description = ''
        JJ: If applied, this commit will...

        JJ: Explain why this change is being made

        JJ: Provide links to any relevant tickets, articles or other resources

        JJ: -------------------------------------------
      '';
    };
  };

  programs.fish = {
    enable = true;

    loginShellInit = ''
      # This is needed to workaround the PATH being set in the wrong order.
      # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1030877541
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

      fish_add_path $HOME/bin

      set -g fish_greeting
      set __done_min_cmd_duration 2000

    '';
    interactiveShellInit = lib.concatStringsSep "\n" (
      map builtins.readFile [
        ./fish/abbr.fish
        ./fish/homebrew.fish
        ./fish/jujutsu.fish
        ./fish/prompt.fish
        # Dynamic jujutsu completions from https://gist.github.com/bnjmnt4n/9f47082b8b6e6ed2b2a805a1516090c8:
        (pkgs.fetchurl {
          url = "https://gist.githubusercontent.com/bnjmnt4n/9f47082b8b6e6ed2b2a805a1516090c8/raw/d93853a40ff8c566c1ce5fcea2a34c0095e689d7/jj.fish";
          hash = "sha256-Ac6ssscmUF6EZx8lOWYDnx54x5/GMctndSLnTFJLLNc";
        })
        (pkgs.fetchurl {
          # same as https://iterm2.com/shell_integration/fish but a stable URL
          url = "https://raw.githubusercontent.com/gnachman/iTerm2/6fc691289b95e874527775687eefc5dffd06c167/Resources/shell_integration/iterm2_shell_integration.fish";
          hash = "sha256-aKTt7HRMlB7htADkeMavWuPJOQq1EHf27dEIjKgQgo0=";
        })
      ]
    );
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
    defaultEditor = true;
    settings = {
      theme = "fleet_dark";
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
        "{" = [ "goto_prev_paragraph" ];
        "}" = [ "goto_next_paragraph" ];
      };
    };

    languages = {
      language-server.pyright = {
        command = "pyright-langserver";
        args = [ "--stdio" ];
        config.reportMissingtypeStubs = false;
      };

      language-server.ruff = {
        command = "ruff";
        args = [ "server" ];
      };

      language-server.pylsp.config.pylsp.plugins = {
        pylsp-mypy = {
          enabled = true;
          live_mode = true;
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
        }
        {
          name = "python";
          auto-format = true;
          language-servers = [
            {
              name = "ruff";
              only-features = [
                "format"
                "diagnostics"
                "code-action"
              ];
            }
            {
              name = "pyright";
              except-features = [
                "format"
                "diagnostics"
              ];
            }
            {
              name = "pylsp";
              only-features = [
                "diagnostics"
                "code-action"
              ];
            }
          ];
        }
      ];
    };

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
    pbclean = "pbpaste | pbcopy";
    t = "cd (mktemp -p /tmp -d stuff.XXXXXXXXX)";
  };
  home.packages = with pkgs; [
    _1password-cli
    awscli2
    age
    bashInteractive
    cachix
    comma
    coreutils
    curl
    difftastic
    findutils
    gh
    grc
    httpie
    hyperfine
    jq
    nodePackages.npm
    nodejs
    openssh
    ripgrep
    rsync
    s3cmd
    shellcheck
    socat
    sops
    spacer
    tailscale
    tmux
    tree
    nil
    nixfmt-rfc-style
    wget
    uv
    unixtools.watch

    (pkgs.runCommand "all-the-pythons" { } ''
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
