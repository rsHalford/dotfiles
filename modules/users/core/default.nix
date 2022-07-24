{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.core;
  terminal = config.richard.terminal.emulator.program;
  terminal-editor = config.richard.terminal.utilities.editor;
  graphical-editor = config.richard.graphical.utilities.editor;
  preferred-browser = config.richard.browser.preferred;
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
        EDITOR = "${terminal-editor}";
        VISUAL = "${graphical-editor}";
        BROWSER = "${preferred-browser}";
        TERM = if "${terminal}" == "footclient" then "foot" else "${terminal}";
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
        element-desktop = {
          name = "Element";
          genericName = "Matrix Client";
          type = "Application";
          exec = "element-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland %u";
          icon = "element";
          categories = [ "Network" "InstantMessaging" "Chat" ];
          mimeType = [ "x-scheme-handler/element" ];
        };
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/png" = "img.desktop";
          "image/jpeg" = "img.desktop";
          "image/gif" = "img.desktop";
          "x-scheme-handler/mailto" = "thunderbird.desktop";
          # "text/plain" = "emacsclient.desktop";
          # "text/x-shellscript" = "emacsclient.desktop";
          "text/html" = "org.qutebrowser.qutebrowser.desktop";
          "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
          "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
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
