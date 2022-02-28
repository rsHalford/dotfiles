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
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      bat
      curl
      exa
      fzf
      htop
      neofetch

      # acpi
      # bottom
      # fd
      # gawk
      # gnused
      # jq
      # manix
      # nix-index
      # pciutils
      # pstree
      # ripgrep
      # unzip
      # wget
    ];
    programs = {
      bat = {
        enable = true;
        config = {
          theme = "gruvbox-dark";
          italic-text = "always";
          #paging = never;
          #pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
          #map-syntax = [
	  # "*.ino:C++";
          # ".ignore:Git Ignore";
	  #];
          style = "numbers,changes,grid";
        };
      };
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
      htop = {
        enable = true;
        settings = { };
      }; 
    };
  };
}
