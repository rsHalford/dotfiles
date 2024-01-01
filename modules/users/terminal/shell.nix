{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.terminal.shell;
  terminal-editor = config.richard.terminal.utilities.editor;
  foreground = "c0caf5"; # white
  background = "1a1b26"; # black
  regular0 = "15161e"; # black
  regular1 = "f7768e"; # red
  regular3 = "e0af68"; # yellow
  regular4 = "7aa2f7"; # blue
  regular5 = "bb9af7"; # magenta
  regular6 = "7dcfff"; # cyan
  regular7 = "a9b1d6"; # white
  color16 = "ff9e64"; # orange
in {
  options.richard.terminal.shell = {
    enable = mkOption {
      description = "Enable terminal shell";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      starship
      zsh
      zsh-history-substring-search
    ];
    programs = {
      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = false;
          battery = {
            discharging_symbol = "󰂃";
            display = [
              {
                threshold = 10;
                style = "bold red";
              }
              {
                threshold = 30;
                style = "bold yellow";
              }
            ];
          };
          character = {
            success_symbol = "[](bold green)";
            error_symbol = "[](bold red)";
            vicmd_symbol = "[](bold yellow)";
          };
          cmd_duration = {
            disabled = false;
          };
          command_timeout = 1000;
          directory = {
            style = "blue";
            read_only = " ";
            read_only_style = "yellow";
            fish_style_pwd_dir_length = 1;
          };
          docker_context = {
            symbol = " ";
          };
          elixir = {
            symbol = " ";
          };
          erlang = {
            symbol = " ";
          };
          git_branch = {
            always_show_remote = true;
            symbol = " ";
          };
          git_commit = {
            tag_symbol = " ";
          };
          git_status = {
            style = "bold yellow";
            conflicted = "󰇼";
            ahead = ''''${count}'';
            behind = ''''${count}'';
            diverged = ''''${ahead_count}⇣''${behind_count}'';
            untracked = "";
            stashed = "";
            modified = "";
            staged = "[\($count\)](green)";
            renamed = "";
            deleted = "󰆴";
          };
          golang = {
            symbol = "󰟓 ";
          };
          line_break = {
            disabled = false;
          };
          lua = {
            symbol = " ";
          };
          nix_shell = {
            symbol = " ";
          };
          nodejs = {
            symbol = "󰎙 ";
            format = "via [$symbol]($style)";
          };
          package = {
            disabled = true;
            symbol = " ";
          };
          php = {
            symbol = "󰌟 ";
          };
          python = {
            symbol = " ";
            style = "green";
            format = ''via [''${symbol}(\($virtualenv\))]($style)'';
          };
          ruby = {
            symbol = " ";
          };
          rust = {
            symbol = " ";
          };
          swift = {
            symbol = "󰛥 ";
          };
        };
      };
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        enableVteIntegration = true;
        autocd = true;
        dotDir = ".config/zsh";
        envExtra = ''
          export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
            --color=fg:#${foreground},bg:#${background},hl:#${regular7}
            --color=fg+:#${regular3},bg+:#${regular0},hl+:#${regular3}
            --color=info:#${regular6},prompt:#${regular4},pointer:#${regular5}
            --color=marker:#${color16},spinner:#${regular1},header:#${color16}"
        '';
        history = {
          expireDuplicatesFirst = true;
          ignoreDups = false;
          ignorePatterns = [];
          ignoreSpace = true;
          path = "${config.xdg.dataHome}/zsh/.zsh_history";
          save = 1000000;
          size = 1000000;
        };
        initExtra = ''
          zmodload -i zsh/complist
          zstyle ":completion:*" menu select
          zstyle ":completion:*" matcher-list "" "m:{a-z}={A-Z}" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"
          zle -N history-substring-search-up
          zle -N history-substring-search-down
          setopt auto_pushd
          setopt correct
          setopt globdots
          setopt hist_ignore_all_dups
          bindkey -v
          bindkey "$terminfo[kcuu1]" history-substring-search-up
          bindkey "$terminfo[kcud1]" history-substring-search-down
          bindkey -M vicmd "k" history-substring-search-up
          bindkey -M vicmd "j" history-substring-search-down
          typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=default,fg=magenta,underline"
          typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=default,fg=yellow,underline"
          export GPG_TTY="$(tty)"
          export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
          gpgconf --launch gpg-agent

          flakify() {
            if [ ! -e flake.nix ]; then
              nix flake new -t github:nix-community/nix-direnv .
            elif [ ! -e .envrc ]; then
              echo "use flake" > .envrc
              direnv allow
            fi
          }

          gwj() {
            local out query
            query="$1"
            match=$(git worktree list | grep "$query")
            if [[ -n "$match" ]]; then
              out=$(
                git worktree list |
                fzf --preview='git log --oneline -n10 {2}' --query "$query" -1 |
                awk '{print $1}'
              )
              cd "$out" || exit
            else
              printf "%s%s\n" "Worktree does not exist: " "$query"
            fi
          }

          gwa() {
            local dir out query
            query="$1"
            match=$(git branch --all | grep "$query")
            if [[ -z "$match" ]]; then
              printf "%s%s\n" "Branch does not exist: " "$query"
              dir=$(basename "$query")
            else
              out=$(
                git branch --all |
                fzf --preview='git log --oneline -n10 {2}' --query "$query" -1 |
                awk '{print $NF}'
              )
              dir=$(basename "$out")
            fi
            git worktree add "$dir"
            cd "$dir"
          }

          tmk() {
            local out query
            query="$1"
            out=$(
              tmux list-sessions -F "#S (#{session_windows} windows)" |
              fzf --query "$query" -1 |
              awk '{print $1}'
            )
            tmux kill-session -t "$out" || exit
          }

          zt() {
            local query zettel
            query="$1"
            cd "$ZETTELKASTEN_DIR"
            zettel=$(fd . | fzf --query "$query" -1)
            if [[ -n "$zettel" ]] && [[ "$zettel" == *"journal/20"* ]]; then
              "$EDITOR" "$zettel" -u ./journal/.nvimrc
            elif [[ -n "$zettel" ]]; then
              "$EDITOR" "$zettel"
            fi
            cd - &> /dev/null
          }

          td() {
            cd "$JOURNAL_DIR"
            month="$(date '+%Y/%m/')"
            today="$(date '+%Y/%m/%d')"
            mkdir -p "$month"
            "$EDITOR" "$today"
          }
        '';
        initExtraBeforeCompInit = ''
          source $HOME/.nix-profile/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        '';
        initExtraFirst = "";
        plugins = [];
        shellAliases = {
          ca = "$XDG_CACHE_HOME";
          cat = "bat";
          cf = "$XDG_CONFIG_HOME";
          cp = "cp -i";
          dc = "$XDG_DOCUMENTS_DIR";
          dl = "$XDG_DOWNLOAD_DIR";
          dot = "$DOTFILES_DIR";
          e = "${terminal-editor}";
          fd = "fd -H";
          # find = "fd";
          g = "git";
          ga = "git add";
          gaa = "git add .";
          gb = "git branch";
          gc = "git commit -v";
          gca = "git commit --amend";
          gcb = "git checkout -b";
          gcl = "git clone";
          gcm = "git commit -m";
          gco = "git checkout";
          gd = "git diff";
          gf = "git fetch";
          glg = "git log --stat";
          gm = "git merge";
          gmv = "git mv";
          gob = "go build -v";
          gof = "gofmt -d -s -w .";
          gpl = "git pull";
          gps = "git push";
          grb = "git rebase";
          grep = "grep -i --color=auto --exclude-dir={.git,node_modules}";
          grm = "git rm";
          grs = "git restore --staged .";
          gsh = "git secret hide";
          gsr = "git secret reveal -f";
          gst = "git status --short --branch";
          gw = "git worktree";
          gwc = "worktree-clone";
          gwl = "git worktree list";
          gwp = "git worktree prune";
          gwr = "git worktree remove";
          h = "${terminal-editor}";
          journal = "$JOURNAL_DIR";
          la = "eza -T -L=3 --group-directories-first";
          lc = "$HOME/.local/";
          lcb = "$HOME/.local/bin/";
          lcs = "$XDG_DATA_HOME";
          ls = "eza -1ar -s=Name --group-directories-first --git --icons=auto";
          mkdir = "mkdir -pv";
          mv = "mv -i";
          pro = "$PROJECTS_DIR";
          # rm = "rm -i";
          tms = "tmux-sessioniser";
          v = "${terminal-editor}";
          work = "$WORK_DIR";
          zettels = "$ZETTELKASTEN_DIR";
        };
        shellGlobalAliases = {}; # aliases substituted anywhere on a line
      };
    };
  };
}
