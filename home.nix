{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.stateVersion = "23.11";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.htop.enable = true;
  programs.fzf.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user.name = "Andreas Pelme";
      user.email = "andreas@pelme.se";
      init.defaultBranch = "main";
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "andreas@pelme.se";
        name = "Andreas Pelme";
      };
      ui.diff-formatter = ":git";
      ui.default-command = "log";
      ui.merge-editor = "vscode";
      ui.conflict-marker-style = "git";
      template-aliases = {
        "format_short_signature(signature)" =
          ''if(signature.email().domain() == "personalkollen.se", signature.email().local(), signature.email())'';

        default_commit_description = ''
          "JJ: If applied, this commit will...

          JJ: Explain why this change is being made

          JJ: Provide links to any relevant tickets, articles or other resources

          "
        '';
      };
      templates = {
        draft_commit_description = ''
          concat(
            coalesce(description, default_commit_description, "\n"),
            "JJ: ----------------\n",
            "JJ: ignore-rest",
            "\n \n",
            diff.stat(80),
            " \n",
            diff.git(),
          )
        '';

      };
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
        ./fish/jujutsu.fish
        ./fish/prompt.fish
        (pkgs.fetchurl {
          # same as https://iterm2.com/shell_integration/fish but a stable URL
          url = "https://raw.githubusercontent.com/gnachman/iTerm2/6fc691289b95e874527775687eefc5dffd06c167/Resources/shell_integration/iterm2_shell_integration.fish";
          hash = "sha256-aKTt7HRMlB7htADkeMavWuPJOQq1EHf27dEIjKgQgo0=";
        })
      ]
    );
    shellInit = ''
      umask 002
    '';
    plugins = with pkgs.fishPlugins; [
      {
        name = "done";
        src = done.src;
      }
    ];
  };

  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      font-family = "FiraCode Nerd Font Mono";
      macos-titlebar-style = "tabs";
      theme = "dracula";
    };
    themes.dracula = {
      palette = [
        "0=#21222c"
        "1=#ff5555"
        "2=#50fa7b"
        "3=#f1fa8c"
        "4=#bd93f9"
        "5=#ff79c6"
        "6=#8be9fd"
        "7=#f8f8f2"
        "8=#6272a4"
        "9=#ff6e6e"
        "10=#69ff94"
        "11=#ffffa5"
        "12=#d6acff"
        "13=#ff92df"
        "14=#a4ffff"
        "15=#ffffff"
      ];
      background = "#212121";
      foreground = "#f8f8f2";
      cursor-color = "#f8f8f2";
      cursor-text = "#282a36";
      selection-foreground = "#f8f8f2";
      selection-background = "#44475a";
    };
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
        continue-comments = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
      keys.normal = {
        "{" = [ "goto_prev_paragraph" ];
        "}" = [ "goto_next_paragraph" ];
        "C-r" = ":reload-all";
      };
    };

    languages = {
      language-server.pyright = {
        command = "pyright-langserver";
        args = [ "--stdio" ];
        config.reportMissingtypeStubs = false;
        config.python.analysis.typeCheckingMode = "off";
      };

      language-server.ruff = {
        command = "ruff";
        args = [ "server" ];
      };

      language-server.pylsp.config.pylsp.plugins = {
        pylsp-mypy.enabled = true;
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
      vim-one
      vim-commentary
      vim-surround
    ];
    extraConfig = builtins.readFile ./vimrc.vim;
  };

  home.shellAliases = {
    pbclean = "pbpaste | pbcopy";
    t = "cd (mktemp -p /tmp -d stuff.XXXXXXXXX)";
  };
  home.packages = with pkgs; [
    age
    bashInteractive
    cachix
    nixos-rebuild-ng
    comma
    coreutils
    curl
    docker-client
    difftastic
    google-cloud-sdk
    exiftool
    findutils
    gh
    grc
    httpie
    hyperfine
    imagemagick
    jjui
    jq
    nil
    nixfmt-rfc-style
    ngrok
    nodejs
    nix-output-monitor
    openssh
    ripgrep
    rsync
    s3cmd
    shellcheck
    socat
    snicat
    sops
    spacer
    tailscale
    tmux
    tree
    unixtools.watch
    uv
    wget
    _1password-cli

    cowsay
    figlet
    lolcat

    cargo
    rustc
    rustfmt
    rust-analyzer
    lldb

    (pkgs.runCommand "all-the-pythons" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.python314}/bin/python $out/bin/python3
      ln -s ${pkgs.python314}/bin/python $out/bin/python

      ln -s ${pkgs.python312}/bin/python $out/bin/python3.12
      ln -s ${pkgs.python313}/bin/python $out/bin/python3.13
      ln -s ${pkgs.python314}/bin/python $out/bin/python3.14
    '')

    (pkgs.writeShellApplication {
      name = "jj-github-pr";
      runtimeInputs = [
        pkgs.git
        pkgs.jujutsu
      ];
      text =

        let
          python = (
            pkgs.python3.withPackages (p: [
              p.pygithub
              p.click
            ])
          );
        in

        ''exec ${python}/bin/python ${./jj_github_pr.py} "$@"'';
    })

  ];

  home.file =

    let
      jjuiConfigDir = (
        if pkgs.stdenv.isDarwin then "Library/Application Support" else config.xdg.configHome
      );
    in
    {
      ".hushlogin".text = "";
      ".psqlrc".text = ''
        \set QUIET ON
        \pset null 'NULL'
        \timing
        \set COMP_KEYWORD_CASE upper
        \set QUIET OFF
      '';
      "${jjuiConfigDir}/jjui/config.toml".text = ''
        [ui]
          auto_refresh_interval = 1
      '';
    };

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PYTHONIOENCODING = "UTF-8";
  };
}
