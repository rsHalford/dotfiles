{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.terminal.emulator;
in
{
  config = mkIf (cfg.program == "footclient") {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          # shell = "\$SHELL"; # (if set, otherwise user's default shell from /etc/passwd)
          # term = "foot"; # (or xterm-256color if built with -Dterminfo=disabled)
          # login-shell = "no";
          font = "JetBrainsMono Nerd Font:style=Regular:size=10";
          font-bold = "JetBrainsMono Nerd Font:style=Bold:size=10";
          font-italic = "JetBrainsMono Nerd Font:style=Italic:size=10";
          font-bold-italic = "JetBrainsMono Nerd Font:style=Bold Italic:size=10";
          # line-height = "";
          letter-spacing = "0";
          horizontal-letter-offset = "0";
          vertical-letter-offset = "0";
          # underline-offset = "";
          box-drawings-uses-font-glyphs = "no";
          dpi-aware = "auto"; # "auto", "yes", "no"
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
          launch = "xdg-open \${url}";
          osc8-underline = "url-mode"; # "url-mode", "always" (even when not clickable)
          # label-letters = "sadfjklewcmpgh";
          # protocols = "http, https, ftp, ftps, file, gemini, gopher";
          # uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+="'()[]";
        };
        cursor = {
          style = "block";
          blink = "no";
          # color = "<inverse foreground/background>";
          beam-thickness = "1.5";
          # underline-thickness = "<font underline thickness>";
        };
        mouse = {
          hide-when-typing = "yes";
          alternate-scroll-mode = "yes";
        };
        colors = {
          foreground = "ebdbb2";
          background = "1d2021";
          # Normal/regular colors (color palette 0-7)
          regular0 = "1d2021"; # black
          regular1 = "cc241d"; # red
          regular2 = "98971a"; # green
          regular3 = "d79921"; # yellow
          regular4 = "458588"; # blue
          regular5 = "b16286"; # magenta
          regular6 = "689d6a"; # cyan
          regular7 = "a89984"; # white
          # Bright colors (color palette 8-15)
          bright0 = "928374"; # bright black
          bright1 = "fb4934"; # bright red
          bright2 = "b8bb26"; # bright green
          bright3 = "fabd2f"; # bright yellow
          bright4 = "83a598"; # bright blue
          bright5 = "d3869b"; # bright magenta
          bright6 = "8ec07c"; # bright cyan
          bright7 = "ebdbb2"; # bright white
          # Dimmed colors (see foot.ini(5) man page)
          dim0 = "32302f"; # dim black
          dim1 = "9d0006"; # dim red
          dim2 = "79740e"; # dim green
          dim3 = "b57614"; # dim yellow
          dim4 = "076678"; # dim blue
          dim5 = "8f3f71"; # dim magenta
          dim6 = "427b58"; # dim cyan
          dim7 = "928374"; # dim white
          # The remaining 256-color palette
          # 16 = "<256-color palette #16>";
          # ...
          # 255 = "<256-color palette #255>";
          alpha = "1.0";
          # Misc colors
          # selection-foreground = "<inverse foreground/background>";
          selection-background = "32302f";
          jump-labels = "1d2021 fe8019";
          # scrollback-indicator = "<regular0> <bright4>";
          # urls = "<regular3>";
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
          select-row = "BTN_LEFT-3";
        };
        tweak = {
          # sixel = "yes";
        };
      };
    };
  };
}
