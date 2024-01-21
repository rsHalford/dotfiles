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
      wget
      wtype

      # acpi
      # manix
      # nix-index
      # pstree
    ];
    programs = {
      bat = {
        enable = true;
        config = {
          theme = "base16-256";
          italic-text = "always";
          style = "numbers,changes,grid";
        };
      };
      bottom.enable = true;
      eza.enable = true;
      fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultOptions = ["-i"];
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
          set -g mode-style "fg=#${theme.colors.base01},bg=#${theme.colors.base09}"
          set -g message-style "fg=#${theme.colors.base0D},bg=#${theme.colors.base00}"
          set -g message-command-style "fg=#${theme.colors.base0D},bg=#${theme.colors.base00}"
          set -g pane-border-style "fg=#${theme.colors.base00}"
          set -g pane-active-border-style "fg=#${theme.colors.base0E}"
          set -g status "on"
          set -g status-justify "left"
          set -g status-style "fg=#${theme.colors.base07},bg=#${theme.colors.base00}"
          set -g status-left-length "100"
          set -g status-left-style NONE
          set -g status-left "#[fg=#${theme.colors.base03},bg=#${theme.colors.base00}] #S #[fg=#${theme.colors.base07},bg=#${theme.colors.base00},nobold,nounderscore,noitalics]"
          set -g status-right-length "100"
          set -g status-right-style NONE
          set -g status-right "#[fg=#${theme.colors.base0E},bg=#${theme.colors.base00}] #h "
          setw -g window-status-activity-style "underscore,fg=#${theme.colors.base05},bg=#${theme.colors.base00}"
          setw -g window-status-separator ""
          setw -g window-status-style "NONE,fg=#${theme.colors.base05},bg=#${theme.colors.base00}"
          setw -g window-status-format "#[fg=#${theme.colors.base05},bg=#${theme.colors.base00},nobold,nounderscore,noitalics] #I #W #F #[fg=#${theme.colors.base07},bg=#${theme.colors.base00},nobold,nounderscore,noitalics]"
          setw -g window-status-current-format "#[fg=#${theme.colors.base0B},bg=#${theme.colors.base01},bold,nounderscore,noitalics] #I #W #F #[fg=#${theme.colors.base07},bg=#${theme.colors.base00},nobold,nounderscore,noitalics]"
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
