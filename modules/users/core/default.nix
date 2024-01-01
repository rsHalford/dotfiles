{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.core;
  monospace = config.richard.fonts.monospace;
  terminal = config.richard.terminal.emulator.program;
  terminal-editor = config.richard.terminal.utilities.editor;
  graphical-editor = config.richard.graphical.utilities.editor;
  preferred-browser = config.richard.browser.http.preferred;
  browser-application =
    if browser == "brave"
    then "brave-browser"
    else browser;
in {
  options.richard = {
    core = {
      enable = mkOption {
        description = "Enable a set of common settings for user setup";
        type = types.bool;
        default = false;
      };
    };

    fonts = {
      monospace = {
        name = mkOption {
          description = "Monospace font";
          type = types.str;
          default = "";
        };

        pkg = mkOption {
          description = "Monospace font";
          type = types.str;
          default = "";
        };
      };

      sans = mkOption {
        description = "Sans-serif font";
        type = types.str;
        default = "";
      };

      serif = mkOption {
        description = "Serif font";
        type = types.str;
        default = "";
      };
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      packages = with pkgs; [
        (nerdfonts.override {fonts = ["${monospace.pkg}"];})
        google-fonts
        xdg-utils
        qmk
        via
        # yt-dlp
        zathura
      ];

      sessionVariables = {
        EDITOR = "${terminal-editor}";
        VISUAL = "${graphical-editor}";
        BROWSER = "${preferred-browser}";
        TERM =
          if "${terminal}" == "footclient"
          then "foot"
          else "${terminal}";
        READER = "zathura";
        VIDEO = "mpv";
        IMAGE = "imv";
      };
    };

    fonts.fontconfig.enable = true;

    programs = {
      zathura = {
        enable = true;
        extraConfig = ''
          set recolor true
          set recolor-keephue true
          set highlight-transparency 0.4
          set statusbar-h-padding 0
          set statusbar-v-padding 0
          set page-padding 1
          map u scroll half-up
          map d scroll half-down
          map D toggle_page_mode
          map r reload
          map R rotate
          map K zoom in
          map J zoom out
          map i recolor
          map p print
        '';
      };
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
        mullvad-vpn = {
          name = "Mullvad GUI";
          genericName = "Mullvad VPN Client";
          type = "Application";
          exec = "mullvad-gui";
          icon = "mullvad-vpn";
          categories = ["Network"];
        };
      };
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/png" = "img.desktop";
          "image/jpeg" = "img.desktop";
          "image/gif" = "img.desktop";
          "text/html" = "${browser-application}.desktop";
          "x-scheme-handler/http" = "${browser-application}.desktop";
          "x-scheme-handler/https" = "${browser-application}.desktop";
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
        desktop = "$HOME/desktop";
        documents = "$HOME/documents";
        download = "$HOME/downloads";
        extraConfig = {
          DOTFILES_DIR = "$HOME/.dotfiles";
          JOURNAL_DIR = "$HOME/documents/journal";
          PROJECTS_DIR = "$HOME/projects";
          WORK_DIR = "$HOME/work";
          ZETTELKASTEN_DIR = "$HOME/documents/zettelkasten";
        };
        music = "$HOME/media/music";
        pictures = "$HOME/media/pictures";
        publicShare = "$HOME/public";
        templates = "$HOME/templates";
        videos = "$HOME/media/videos";
      };
    };
  };
}
