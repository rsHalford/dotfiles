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
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        google-fonts
        xdg-utils
        # yt-dlp
        zathura
      ];

      sessionVariables = {
        EDITOR = "emacsclient -c";
        VISUAL = "nvim";
        BROWSER = "qutebrowser";
        TERM = config.richard.terminal.emulator.program;
        READER = "zathura";
        VIDEO = "mpv";
      };
    };

    fonts.fontconfig.enable = true;

    programs = {
      zathura.enable = true;
    };

    xdg = {
      enable = true;
      desktopEntries = {
        img = {
          name = "imv";
          genericName = "Image viewer";
          type = "Application";
          exec = "imv %F";
          terminal = true;
          icon = "multimedia-photo-viewer";
        };
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/png" = "img.desktop";
          "image/jpeg" = "img.desktop";
          "image/gif" = "img.desktop";
          "x-scheme-handler/mailto" = "emacsclient-mail.desktop";
          "text/plain" = "emacsclient.desktop";
          "text/x-shellscript" = "emacsclient.desktop";
          "application/pdf" = "org.pwmt.zathura.desktop";
          "application/postscript" = "org.pwmt.zathura.desktop";
          "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
          "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
          "x-scheme-handler/sgnl" = "signal-desktop.desktop";
          "x-scheme-handler/signalcaptcha" = "signal.desktop";
          "x-scheme-handler/tg" = "userapp-Telegram Desktop-RE3OI1.desktop";
        };
      };
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "$HOME";
        extraConfig = {
          XDG_PROJECTS_DIR = "$HOME/Projects";
        };
        music = "$HOME/Media/Music";
        pictures = "$HOME/Media/Pictures";
        videos = "$HOME/Media/Videos";
      };
    };
  };
}
