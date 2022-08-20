{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.terminal.utilities;
in
{
  options.richard.terminal.utilities = {
    enable = mkOption {
      description = "Enable command-line utilities";
      type = types.bool;
      default = true;
    };

    editor = mkOption {
      description = "Choose your preferred terminal editor";
      type = types.enum [ "nvim" "emacs -nw" "emacsclient -nw" "hx" ];
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
      jq
      mmv-go
      neofetch
      pulsemixer
      ripgrep
      translate-shell
      unzip
      wev

      # acpi
      # manix
      # nix-index
      # pciutils
      # pstree
      # wget
    ];
    programs = {
      bat = {
        enable = true;
        config = {
          theme = "gruvbox-dark";
          italic-text = "always";
          style = "numbers,changes,grid";
        };
      };
      bottom.enable = true;
      exa.enable = true;
      fzf = {
        enable = true;
        enableZshIntegration = true;
        changeDirWidgetCommand = null; # source command with ALT-C
        changeDirWidgetOptions = [ ]; # ALT-C options
        defaultCommand = null;
        defaultOptions = [
          "-i --preview 'bat --color=always --style=numbers --line-range=:68 {}'"
        ];
        fileWidgetCommand = null; # source command with CTRL-T
        fileWidgetOptions = [ ]; # CTRL-T options
        historyWidgetOptions = [ ]; # CTRL-R options
      };
    };
  };
}
