{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.core;
in
{
  options.richard.core = {
    enable = mkOption {
      description = "Enable a set of common settings for user setup";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [
        git
        # git-crypt
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        mpv
        neovim
        qutebrowser
        # yt-dlp
        zathura
      ];

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        BROWSER = "qutebrowser";
        TERM = "alacritty";
        READER = "zathura";
        VIDEO = "mpv";
      };
    };

    fonts.fontconfig.enable = true;

    programs = {
      # git-crypt.enable = true;
      mpv.enable = true;
      # neofetch.enable = true;
      qutebrowser.enable = true;
      zathura.enable = true;
    };

    xdg = {
      enable = true;
      # mimeApps.defaultApplications = { };
      userDirs = {
        enable = true;
	createDirectories = true;
	desktop = "$HOME";
	music = "$HOME/Media/Music";
	pictures = "$HOME/Media/Pictures";
	videos = "$HOME/Media/Videos";
      };
    };
  };
}
