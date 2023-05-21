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
          set default-bg "#232136"
          set default-fg "#e0def4"
          set statusbar-fg "#e0def4"
          set statusbar-bg "#59546d"
          set inputbar-bg "#817c9c"
          set inputbar-fg "#232136"
          set notification-bg "#817c9c"
          set notification-fg "#232136"
          set notification-error-bg "#817c9c"
          set notification-error-fg "#ea9a97"
          set notification-warning-bg "#817c9c"
          set notification-warning-fg "#f6c177"
          set highlight-color "#3e8fb0"
          set highlight-active-color "#9ccfd8"
          set completion-bg "#817c9c"
          set completion-fg "#9ccfd8"
          set completion-highlight-fg "#e0def4"
          set completion-highlight-bg "#9ccfd8"
          set recolor-lightcolor "#232136"
          set recolor-darkcolor "#e0def4"
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
        element-desktop = {
          name = "Element";
          genericName = "Matrix Client";
          type = "Application";
          exec = "element-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland %u";
          icon = "element";
          categories = ["Network" "InstantMessaging" "Chat"];
          mimeType = ["x-scheme-handler/element"];
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
          "x-scheme-handler/mailto" = "thunderbird.desktop";
          # "text/plain" = "emacsclient.desktop";
          # "text/x-shellscript" = "emacsclient.desktop";
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
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
          DOTFILES_DIR = "$HOME/.dotfiles";
          PROJECTS_DIR = "$HOME/Projects";
          ZETTELKASTEN_DIR = "$HOME/Documents/Zettelkasten";
        };
        music = "$HOME/Media/Music";
        pictures = "$HOME/Media/Pictures";
        videos = "$HOME/Media/Videos";
      };
    };
  };
}
