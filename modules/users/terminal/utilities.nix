{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.terminal.utilities;
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
      exa
      exfat
      fd
      fzf
      gnumake
      hevea
      jq
      libwebp
      libsixel
      mmv-go
      neofetch
      pciutils
      pulsemixer
      ripgrep
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
          theme = "tokyo-night";
          italic-text = "always";
          style = "numbers,changes,grid";
        };
        themes = {
          tokyo-night = builtins.readFile (pkgs.fetchFromGitHub {
              owner = "folke";
              repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
              rev = "56945bd0d312dc3ed84466d7a6cbfc5e44fbbb4e";
              sha256 = "sha256-/a4DMUvLos4TI0SpnnV0Lw2adJXOUNdm2KT125WM1yg=";
            }
            + "/extras/sublime/tokyonight_night.tmTheme");
        };
      };
      bottom.enable = true;
      exa.enable = true;
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
          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi V send-keys -X rectangle-toggle
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
          bind -r ^ last-window
          bind -r k select-pane -U
          bind -r j select-pane -D
          bind -r h select-pane -L
          bind -r l select-pane -R
        '';
        historyLimit = 50000;
        keyMode = "vi";
        mouse = true;
        prefix = "C-a";
        shortcut = "a";
        terminal = "screen-256color";
        tmuxinator.enable = false;
        tmuxp.enable = false;
      };
    };
  };
}
