{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.terminal.shell;
  terminal-editor = config.richard.terminal.utilities.editor;
in
{
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
          aws = {
            symbol = " ";
          };
          battery = {
            discharging_symbol = "";
            display = [
              { threshold = 10; style = "bold red"; }
              { threshold = 30; style = "bold yellow"; }
            ];
          };
          character = {
            success_symbol = "[ ](bold green)";
            error_symbol = "[ ](bold red)";
            vicmd_symbol = "[ ](bold yellow)";
          };
          cmd_duration = {
            disabled = true;
          };
          crystal = {
            symbol = " ";
          };
          dart = {
            symbol = " ";
          };
          directory = {
            style = "blue";
            read_only = " ";
            read_only_style = "yellow";
            fish_style_pwd_dir_length = 1;
          };
          docker_context = {
            symbol = " ";
          };
          dotnet = {
            symbol = " ";
          };
          elixir = {
            symbol = " ";
          };
          elm = {
            symbol = " ";
          };
          erlang = {
            symbol = " ";
          };
          gcloud = {
            symbol = " ";
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
            conflicted = "";
            ahead = ''''${count}'';
            behind = ''''${count}'';
            diverged = ''''${ahead_count}⇣''${behind_count}'';
            untracked = "";
            stashed = "";
            modified = "";
            staged = "[\($count\)](green)";
            renamed = "";
            deleted = "";
          };
          golang = {
            symbol = "ﳑ ";
          };
          helm = {
            symbol = "ﴱ ";
          };
          java = {
            symbol = " ";
          };
          julia = {
            symbol = " ";
          };
          kotlin = {
            symbol = " ";
          };
          line_break = {
            disabled = true;
          };
          lua = {
            symbol = " ";
          };
          nim = {
            symbol = " ";
          };
          nix_shell = {
            symbol = " ";
          };
          nodejs = {
            symbol = " ";
            format = "via [$symbol]($style)";
          };
          openstack = {
            symbol = " ";
          };
          package = {
            disabled = true;
            symbol = " ";
          };
          php = {
            symbol = " ";
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
            symbol = "ﯣ ";
          };
        };
      };
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        enableVteIntegration = true;
        autocd = true;
        dotDir = ".config/zsh";
        envExtra = ''
          export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
            --color=fg:#e0def4,bg:#2a273f,hl:#6e6a86
            --color=fg+:#908caa,bg+:#232136,hl+:#908caa
            --color=info:#9ccfd8,prompt:#f6c177,pointer:#c4a7e7
            --color=marker:#ea9a97,spinner:#eb6f92,header:#ea9a97"
        '';
        history = {
          expireDuplicatesFirst = true;
          ignoreDups = false;
          ignorePatterns = [ ];
          ignoreSpace = true;
          path = "${config.xdg.dataHome}/zsh/.zsh_history";
          save = 1000000;
          size = 1000000;
        };
        initExtra =
          ''
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
          '';
        initExtraBeforeCompInit =
          ''
            source .nix-profile/share/zsh-history-substring-search/zsh-history-substring-search.zsh
          '';
        initExtraFirst = "";
        plugins = [ ];
        shellAliases = {
          ca = "$HOME/.cache/";
          cat = "bat";
          cf = "$HOME/.config/";
          cp = "cp -i";
          dl = "$HOME/Downloads";
          dc = "$HOME/Documents";
          dot = "$HOME/.dotfiles";
          e = "${terminal-editor}";
          fd = "fd -HI";
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
          gst = "git status -u";
          gw = "git worktree";
          gwa = "git worktree add";
          gwr = "git worktree remove";
          gwp = "git worktree prune";
          h = "${terminal-editor}";
          la = "exa -T -L=3 --group-directories-first";
          lc = "$HOME/.local/";
          lcb = "$HOME/.local/bin/";
          lcs = "$HOME/.local/share/";
          ls = "exa -lagh -s=.Name --time-style=iso --git --group-directories-first --colour-scale";
          mkdir = "mkdir -pv";
          mv = "mv -i";
          pro = "$HOME/Projects";
          # rm = "rm -i";
          v = "${terminal-editor}";
        };
        shellGlobalAliases = { }; # aliases substituted anywhere on a line
      };
    };
  };
}
