{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.terminal.utilities;
  theme = config.richard.theme;
in {
  options.richard.terminal.utilities = {
    enable = mkOption {
      description = "Enable command-line utilities";
      type = types.bool;
      default = true;
    };

    editor = mkOption {
      description = "Choose your preferred terminal editor";
      type = types.enum ["nvim" "emacs -nw" "emacsclient -nw" "hx"];
      default = "nvim";
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      alsa-utils
      bat
      bottom
      curl
      eza
      exfat
      fd
      fzf
      gnumake
      hevea
      jq
      libwebp
      libsixel
      mmv-go
      ncpamixer
      neofetch
      pamixer
      pciutils
      ripgrep
      scripts.tmuxTools
      shell_gpt
      translate-shell
      unzip
      usbutils
      ventoy
      wev
      wtype

      # acpi
      # manix
      # nix-index
      # pstree
      # wget
    ];
    programs = {
      bat = {
        enable = true;
        config = {
          theme = theme.name;
          italic-text = "always";
          style = "numbers,changes,grid";
        };
        themes = {
          tokyonight = builtins.readFile (pkgs.fetchFromGitHub {
              owner = "folke";
              repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
              rev = "56945bd0d312dc3ed84466d7a6cbfc5e44fbbb4e";
              sha256 = "sha256-/a4DMUvLos4TI0SpnnV0Lw2adJXOUNdm2KT125WM1yg=";
            }
            + "/extras/sublime/tokyonight_night.tmTheme");
        };
      };
      bottom.enable = true;
      eza.enable = true;
      fzf = {
        enable = true;
        enableZshIntegration = true;
        changeDirWidgetCommand = null; # source command with ALT-C
        changeDirWidgetOptions = []; # ALT-C options
        defaultCommand = null;
        defaultOptions = [
          "-i --preview 'bat --color=always --style=numbers --line-range=:68 {}'"
        ];
        fileWidgetCommand = null; # source command with CTRL-T
        fileWidgetOptions = []; # CTRL-T options
        historyWidgetOptions = []; # CTRL-R options
      };
      tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        escapeTime = 0;
        extraConfig = ''
          # Vim Keybinds
          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi V send-keys -X rectangle-toggle
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
          bind -r ^ last-window
          bind -r k select-pane -U
          bind -r j select-pane -D
          bind -r h select-pane -L
          bind -r l select-pane -R

          # Styling
          set -g set-titles on
          set -g mode-style "fg=#${theme.regular0},bg=#${theme.color16}"
          set -g message-style "fg=#${theme.regular4},bg=#${theme.background}"
          set -g message-command-style "fg=#${theme.regular4},bg=#${theme.background}"
          set -g pane-border-style "fg=#${theme.background}"
          set -g pane-active-border-style "fg=#${theme.regular5}"
          set -g status "on"
          set -g status-justify "left"
          set -g status-style "fg=#${theme.foreground},bg=#${theme.background}"
          set -g status-left-length "100"
          set -g status-right-length "100"
          set -g status-left-style NONE
          set -g status-right-style NONE
          set -g status-left "#[fg=#${theme.bright0},bg=#${theme.background}] #S #[fg=#${theme.foreground},bg=#${theme.background},nobold,nounderscore,noitalics]"
          set -g status-right "#[fg=#${theme.regular4},bg=#${theme.background}] #h "
          setw -g window-status-activity-style "underscore,fg=#${theme.regular7},bg=#${theme.background}"
          setw -g window-status-separator ""
          setw -g window-status-style "NONE,fg=#${theme.regular7},bg=#${theme.background}"
          setw -g window-status-format "#[fg=#${theme.regular7},bg=#${theme.background},nobold,nounderscore,noitalics] #I #W #F #[fg=#${theme.foreground},bg=#${theme.background},nobold,nounderscore,noitalics]"
          setw -g window-status-current-format "#[fg=#${theme.regular2},bg=#${theme.regular0},bold,nounderscore,noitalics] #I #W #F #[fg=#${theme.foreground},bg=#${theme.background},nobold,nounderscore,noitalics]"
        '';
        historyLimit = 50000;
        keyMode = "vi";
        mouse = true;
        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.yank;
            extraConfig = ''
              set -g @shell-mode 'vi'
            '';
          }
          {
            plugin = tmuxPlugins.resurrect;
            extraConfig = ''
              set -g @resurrenct-processes 'helix newsboat'
            '';
          }
          {
            plugin = tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-boot 'on'
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '10'
            '';
          }
        ];
        prefix = "C-a";
        shortcut = "a";
        terminal = "tmux-256color";
        tmuxinator.enable = false;
        tmuxp.enable = false;
      };
    };
  };
}
