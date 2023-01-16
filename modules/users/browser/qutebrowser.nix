{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.browser.http;
  terminal = config.richard.terminal.emulator.program;
  terminal-editor = config.richard.terminal.utilities.editor;
  bg0_hard = "#1d2021";
  bg0_soft = "#32302f";
  bg0_normal = "#282828";
  bg0 = "#282828";
  bg1 = "#3c3836";
  bg2 = "#504945";
  bg3 = "#665c54";
  bg4 = "#7c6f64";
  fg0 = "#fbf1c7";
  fg1 = "#ebdbb2";
  fg2 = "#d5c4a1";
  fg3 = "#bdae93";
  fg4 = "#a89984";
  bright_red = "#fb4934";
  bright_green = "#b8bb26";
  bright_yellow = "#fabd2f";
  bright_blue = "#83a598";
  bright_purple = "#d3869b";
  bright_aqua = "#8ec07c";
  bright_gray = "#928374";
  bright_orange = "#fe8019";
  dark_red = "#cc241d";
  dark_green = "#98971a";
  dark_yellow = "#d79921";
  dark_blue = "#458588";
  dark_purple = "#b16286";
  dark_aqua = "#689d6a";
  dark_gray = "#a89984";
  dark_orange = "#d65d0e";
in {
  imports = [~/.dotfiles/secrets/qutebrowser];

  options.richard.browser.http.qutebrowser = {
    enable = mkOption {
      description = "Enable qutebrowser";
      type = types.bool;
      default = false;
    };
  };

  config = {
    programs.qutebrowser = {
      enable = cfg.qutebrowser.enable;
      enableDefaultBindings = true;
      aliases = {
        "q" = "close";
        "qa" = "quit";
        "w" = "session-save";
        "wp" = "set-cmd-text :session-save -o -p private";
        "wq" = "quit --save";
        "wqa" = "quit --save";
      };
      # extraConfig = "";
      keyBindings = {
        command = {
          "<Ctrl-J>" = "completion-item-focus next";
          "<Ctrl-K>" = "completion-item-focus prev";
        };
        normal = {
          ",c" = "config-edit";
          "gp" = "set-cmd-text -s :open -p";
          ",r" = "spawn --userscript readability";
          ",sd" = "set-cmd-text -s :session-delete";
          ",sl" = "set-cmd-text -s :session-load";
          ",ss" = "set-cmd-text -s :session-save";
          ",sp" = "set-cmd-text -s :session-save -o -p";
          ",S" = "config-cycle statusbar.show in-mode always";
          ",T" = "config-cycle tabs.show switching always;; config-cycle tabs.title.format {index:>2} '{index:>2}{audio} {current_title}';; config-cycle tabs.width 40 '20%'";
          ",tg" = "set-cmd-text -s :tab-give";
          ",tp" = "set-cmd-text -s :tab-pin";
          ",ts" = "set-cmd-text -s :tab-select";
          ",v" = "spawn --userscript view_in_mpv";
          ",V" = "hint links userscript view_in_mpv";
          # ";v" = "hint --rapid links userscript view_in_mpv";
          "zl" = "spawn --userscript qute-pass";
          "zul" = "spawn --userscript qute-pass --username-only";
          "zpl" = "spawn --userscript qute-pass --password-only";
        };
      };
      # keyMappings = { };
      loadAutoconfig = true;
      settings = {
        auto_save.session = true;
        changelog_after_upgrade = "patch";
        completion = {
          height = "33%";
          open_categories = ["searchengines" "quickmarks" "filesystem" "history"];
          scrollbar.padding = 1;
          scrollbar.width = 7;
          shrink = true;
          timestamp_format = "%H:%M %d-%m-%y";
        };
        confirm_quit = ["downloads"];
        content = {
          autoplay = false;
          blocking.adblock.lists = [
            "https://easylist.to/easylist/easylist.txt"
            "https://easylist.to/easylist/easyprivacy.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2020.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2021.txt"
            "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters-2022.txt"
          ];
          blocking.method = "both";
          fullscreen.window = true;
          headers.accept_language = "en-GB,en-US;q=0.9,en;q=0.8";
          notifications.enabled = false;
        };
        downloads = {
          location.directory = "~/Downloads";
          location.suggestion = "both";
          position = "bottom";
          remove_finished = 180000;
        };
        editor.command = ["${terminal}" "-e" "${terminal-editor}" "{}"];
        keyhint.delay = 0;
        scrolling = {
          bar = "never";
          smooth = true;
        };
        session.default_name = "default";
        spellcheck.languages = ["en-GB"];
        statusbar = {
          show = "in-mode";
          widgets = ["keypress" "history" "url" "progress" "scroll" "tabs"];
        };
        tabs = {
          indicator.width = 0;
          new_position.unrelated = "next";
          position = "left";
          last_close = "default-page";
          select_on_remove = "prev";
          show = "switching";
          show_switching_delay = 1500;
          title.format = "{index:>2}";
          title.format_pinned = "{index:>2}";
          width = 40;
        };
        url = {
          default_page = "/home/richard/.dotfiles/modules/users/browser/start/index.html";
          open_base_url = true;
          start_pages = ["/home/richard/.dotfiles/modules/users/browser/start/index.html"];
        };
        window.title_format = "{perc}{audio}{private}{current_title}{title_sep}qutebrowser";
        zoom.levels = [
          "25%"
          "33%"
          "50%"
          "67%"
          "75%"
          "90%"
          "100%"
          "110%"
          "125%"
          "133%"
          "150%"
          "175%"
          "200%"
          "250%"
          "300%"
          "400%"
          "500%"
        ];
        colors = {
          completion = {
            category = {
              bg = bg0;
              border = {
                bottom = bg0;
                top = bg0;
              };
              fg = bright_yellow;
            };
            even.bg = bg0_hard;
            fg = [fg1 bright_blue bright_yellow];
            item.selected = {
              bg = bg1;
              border = {
                bottom = bg1;
                top = bg1;
              };
              fg = fg1;
              match.fg = dark_red;
            };
            match.fg = dark_red;
            odd.bg = bg0_hard;
            scrollbar = {
              bg = bg0;
              fg = fg4;
            };
          };
          contextmenu = {
            disabled = {
              bg = bg0_soft;
              fg = bg4;
            };
            menu = {
              bg = bg0_soft;
              fg = fg1;
            };
            selected = {
              bg = bg2;
              fg = fg0;
            };
          };
          downloads = {
            bar.bg = bg0_hard;
            error = {
              bg = dark_red;
              fg = bg0_hard;
            };
            start = {
              bg = dark_yellow;
              fg = bg0_hard;
            };
            stop = {
              bg = dark_green;
              fg = bg0_hard;
            };
            system = {
              bg = "hsv";
              fg = "hsv";
            };
          };
          hints = {
            bg = bright_yellow;
            fg = bg0;
            match.fg = dark_red;
          };
          keyhint = {
            bg = bg0_hard;
            fg = fg1;
            suffix.fg = bright_yellow;
          };
          messages = {
            error = {
              bg = dark_red;
              border = dark_red;
              fg = fg0;
            };
            info = {
              bg = bg0_hard;
              border = bg0_hard;
              fg = fg1;
            };
            warning = {
              bg = dark_orange;
              border = dark_yellow;
              fg = fg1;
            };
          };
          prompts = {
            bg = bg0_soft;
            border = "2px solid #282828";
            fg = fg1;
            selected = {
              bg = bg0_hard;
              fg = fg0;
            };
          };
          statusbar = {
            caret = {
              bg = dark_orange;
              fg = bg0_hard;
              selection = {
                bg = dark_orange;
                fg = bg0_hard;
              };
            };
            command = {
              bg = bg0_hard;
              fg = bright_green;
              private = {
                bg = bg0_hard;
                fg = bright_green;
              };
            };
            insert = {
              bg = bright_blue;
              fg = bg0_hard;
            };
            normal = {
              bg = bg0_hard;
              fg = fg1;
            };
            passthrough = {
              bg = bright_purple;
              fg = bg0_hard;
            };
            private = {
              bg = fg1;
              fg = bg0_hard;
            };
            progress.bg = fg1;
            url = {
              error.fg = dark_red;
              fg = fg1;
              hover.fg = bright_blue;
              success = {
                http.fg = fg2;
                https.fg = fg0;
              };
              warn.fg = dark_yellow;
            };
          };
          tabs = {
            bar.bg = bg0_hard;
            even = {
              bg = bg0_hard;
              fg = fg1;
            };
            odd = {
              bg = bg0_hard;
              fg = fg1;
            };
            pinned = {
              even = {
                bg = dark_green;
                fg = bg0;
              };
              odd = {
                bg = dark_green;
                fg = bg0;
              };
              selected = {
                even = {
                  bg = bright_green;
                  fg = bg0;
                };
                odd = {
                  bg = bright_green;
                  fg = bg0;
                };
              };
            };
            selected = {
              even = {
                bg = bg1;
                fg = fg1;
              };
              odd = {
                bg = bg1;
                fg = fg1;
              };
            };
          };
          webpage = {
            bg = fg1;
            darkmode = {
              enabled = false;
              policy.images = "never";
            };
            preferred_color_scheme = "dark";
          };
        };
        hints = {
          border = "2px solid #d79921";
          # padding = {
          #   top = 0;
          #   bottom = 1;
          #   left = 3;
          #   right = 3;
          # };
          radius = 1;
        };
        keyhint.radius = 1;
        prompt.radius = 2;
        # statusbar.padding = {
        #   top = 1;
        #   bottom = 1;
        #   left = 0;
        #   right = 1;
        # };
        # tabs.padding = {
        #   top = 1;
        #   bottom = 1;
        #   left = 0;
        #   right = 0;
        # };
        fonts = {
          contextmenu = "Noto Sans";
          default_family = ["JetBrainsMono Nerd Font"];
          default_size = "14px";
          web.family = {
            sans_serif = "Noto Sans";
            serif = "Noto Serif";
          };
        };
      };
    };
  };
}
