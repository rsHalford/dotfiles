{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.terminal.emulator;
  monospace = config.richard.fonts.monospace.name;
  theme = config.richard.theme;
  selection-foreground = "c0caf5";
  selection-background = "33467c";
  urls-color = "73daca";
  cursor-color = "c0caf5 33467c";
in {
  config = mkIf (cfg.program == "foot") {
    programs.foot = {
      enable = true;
      server.enable = false;
      settings = {
        main = {
          # shell = "\$SHELL"; # (if set, otherwise user's default shell from /etc/passwd)
          # term = "foot"; # (or xterm-256color if built with -Dterminfo=disabled)
          # login-shell = "no";
          font = "${monospace} Nerd Font:style=Regular:size=14";
          font-bold = "${monospace} Nerd Font:style=Bold:size=14";
          font-italic = "${monospace} Nerd Font:style=Italic:size=14";
          font-bold-italic = "${monospace} Nerd Font:style=Bold Italic:size=14";
          # line-height = "";
          letter-spacing = "0";
          horizontal-letter-offset = "0";
          vertical-letter-offset = "0";
          # underline-offset = "";
          box-drawings-uses-font-glyphs = "no";
          dpi-aware = "no"; # "auto", "yes", "no"
          pad = "5x2"; # optionally append 'center'
          resize-delay-ms = "100";
          # initial-window-size-pixels = "700x500";  # Or,
          # initial-window-size-chars = "<COLSxROWS>";
          initial-window-mode = "windowed"; # "windowed", "maximized", "fullscreen"
          # title = "foot";
          # locked-title = "no";
          # app-id = "foot";
          bold-text-in-bright = "palette-based"; # "yes", "no", "palette-based"
          # word-delimiters = ",│`|:"'()[]{}<>";
          notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}"; # "${app-id}", "${window-title}", "${title}", "${body}"
          notify-focus-inhibit = "yes";
          selection-target = "primary"; # "primary", "clipboard", "both", "none"
          workers = "4"; # defaults to number of available CPUs (inc. SMT)
        };
        # bell = {
        #   urgent = "no";
        #   notify = "no";
        #   command = "";
        #   command-focused = "no";
        # };
        scrollback = {
          lines = "100000";
          multiplier = "2.0";
          indicator-position = "relative"; # "relative", "fixed", "none"
          indicator-format = "line"; # "line", "percentage", "none"
        };
        url = {
          launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
          osc8-underline = "url-mode"; # "url-mode", "always" (even when not clickable)
          # label-letters = "sadfjklewcmpgh";
          # protocols = "http, https, ftp, ftps, file, gemini, gopher";
          # uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'()[]";
        };
        cursor = {
          style = "block";
          blink = "no";
          color = cursor-color;
          beam-thickness = "1.5";
          # underline-thickness = "<font underline thickness>";
        };
        mouse = {
          hide-when-typing = "yes";
          alternate-scroll-mode = "yes";
        };
        colors = {
          alpha = "0.95";
          foreground = theme.foreground;
          background = theme.background;
          # Normal/regular colors (color palette 0-7)
          regular0 = theme.regular0; # black
          regular1 = theme.regular1; # red
          regular2 = theme.regular2; # green
          regular3 = theme.regular3; # yellow
          regular4 = theme.regular4; # blue
          regular5 = theme.regular5; # magenta
          regular6 = theme.regular6; # cyan
          regular7 = theme.regular7; # white
          # Bright colors (color palette 8-15)
          bright0 = theme.bright0; # black
          bright1 = theme.bright1; # red
          bright2 = theme.bright2; # green
          bright3 = theme.bright3; # yellow
          bright4 = theme.bright4; # blue
          bright5 = theme.bright5; # magenta
          bright6 = theme.bright6; # cyan
          bright7 = theme.bright7; # white
          "16" = theme.color16;
          "17" = theme.color17;
          # Misc colors
          selection-foreground = selection-foreground;
          selection-background = selection-background;
          # jump-labels = "<regular0> <regular3>";
          # scrollback-indicator = "<regular0> <bright4>";
          urls = urls-color;
        };
        csd = {
          preferred = "server";
        };
        key-bindings = {
          # noop = "none";
          scrollback-up-page = "Mod1+u Page_Up";
          # scrollback-up-half-page = "none";
          # scrollback-up-line = "none";
          scrollback-down-page = "Mod1+d Page_Down";
          # scrollback-down-half-page = "none";
          # scrollback-down-line = "none";
          scrollback-home = "Mod1+g Home";
          scrollback-end = "Mod1+Shift+g End";
          clipboard-copy = "Control+Shift+c XF86Copy";
          clipboard-paste = "Control+Shift+v Control+p XF86Paste";
          primary-paste = "Shift+Insert Control+Shift+p";
          search-start = "Control+Shift+r Control+slash";
          font-increase = "Control+plus Control+KP_Add";
          font-decrease = "Control+minus Control+KP_Subtract";
          font-reset = "Control+equal Control+0 Control+KP_0";
          spawn-terminal = "Mod4+Return Control+Shift+n";
          # minimize = "none";
          # maximize = "none";
          # fullscreen = "none";
          # pipe-visible = "[sh -c \"xurls | tac | uniq | rofi -dmenu | xargs -r $(echo $BROWSER)\"] none";
          # pipe-scrollback = "[sh -c \"xurls | tac | uniq | rofi -dmenu | xargs -r $(echo $BROWSER)\"] none";
          # pipe-selected = "[xargs -r $(echo $BROWSER)] none";
          show-urls-launch = "Control+f";
          show-urls-persistent = "Control+Shift+f";
          show-urls-copy = "Control+y";
        };

        search-bindings = {
          cancel = "Control+g Control+c Escape";
          commit = "Return";
          find-prev = "Control+Shift+n";
          find-next = "Control+n";
          cursor-left = "Left Control+h";
          cursor-left-word = "Control+Left Control+b";
          cursor-right = "Right Control+l";
          cursor-right-word = "Control+Right Control+w";
          cursor-home = "Home Control+Shift+6";
          cursor-end = "End Control+Shift+4";
          delete-prev = "BackSpace";
          delete-prev-word = "Mod1+BackSpace Control+BackSpace";
          delete-next = "Delete";
          delete-next-word = "Control+Delete";
          extend-to-word-boundary = "Control+e";
          extend-to-next-whitespace = "Control+Shift+e";
          clipboard-paste = "Control+Shift+v Control+p XF86Paste";
          primary-paste = "Shift+Insert Control+Shift+p";
        };
        url-bindings = {
          cancel = "Control+g Control+c Control+d Escape";
          toggle-url-visible = "t";
        };
        text-bindings = {
          # \x03 = "Mod4+c";  # Map Super+c -> Ctrl+c
        };
        mouse-bindings = {
          selection-override-modifiers = "Shift";
          primary-paste = "BTN_MIDDLE";
          select-begin = "BTN_LEFT";
          select-begin-block = "Control+BTN_LEFT";
          select-extend = "BTN_RIGHT";
          select-extend-character-wise = "Control+BTN_RIGHT";
          select-word = "BTN_LEFT-2";
          select-word-whitespace = "Control+BTN_LEFT-2";
          select-quote = "BTN_LEFT-3";
          select-row = "BTN_LEFT-4";
        };
        tweak = {
          # sixel = "yes";
        };
      };
    };
  };
}
