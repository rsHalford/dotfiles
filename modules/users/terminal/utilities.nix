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
      mmv-go
      neofetch
      pciutils
      pulsemixer
      ripgrep
      shell_gpt
      translate-shell
      unzip
      usbutils
      ventoy-bin
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
          theme = "rose-pine";
          italic-text = "always";
          style = "numbers,changes,grid";
        };
        themes = {
          rose-pine = builtins.readFile (pkgs.fetchFromGitHub {
              owner = "rose-pine";
              repo = "sublime-text"; # Bat uses sublime syntax for its themes
              rev = "ed9ace4c571426070e1046853c13c45d9f12441c";
              sha256 = "sha256-d5CCk15KaIEXFd1LP7q82tcX9evE5G/ZS2GxPCA1K0I=";
            }
            + "/rose-pine.tmTheme");
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
    };
  };
}
