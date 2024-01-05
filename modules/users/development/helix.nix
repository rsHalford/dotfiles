{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.development.helix;
  theme = config.richard.theme;
in {
  options.richard.development.helix = {
    enable = mkOption {
      description = "Enable editing with helix editor";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs = {
      helix = {
        enable = true;
        languages = {
          markdown = [
            {
              name = "markdown";
              file-types = ["md" "mdx" "markdown"];
            }
          ];
          scheme = [
            {
              name = "scheme";
              file-types = ["ss" "scm"];
            }
          ];
        };
        settings = {
          theme = theme.name;
          editor = {
            auto-completion = true;
            auto-format = true;
            auto-info = true;
            auto-save = true;
            bufferline = "multiple";
            color-modes = true;
            completion-trigger-len = 0;
            cursorline = true;
            cursorcolumn = true;
            gutters = ["diff" "diagnostics" "line-numbers" "spacer"];
            idle-timeout = 0;
            line-number = "relative";
            lsp = {
              auto-signature-help = true;
              display-messages = true;
              display-signature-help-docs = true;
            };
            middle-click-paste = true;
            mouse = true;
            rulers = [80 120];
            scroll-lines = 2;
            scrolloff = 8;
            shell = ["sh" "-c"];
            statusline = {
              left = ["mode" "spinner" "file-name"];
              center = [];
              right = [
                "diagnostics"
                "file-encoding"
                "file-type"
                "position"
              ];
              separator = "│";
              mode = {
                normal = "NORMAL";
                insert = "INSERT";
                select = "SELECT";
              };
            };
            true-color = true;
            auto-pairs = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "block";
            };
            search = {
              smart-case = true;
              wrap-around = true;
            };
            whitespace = {
              render = {
                newline = "none";
                space = "none";
                tab = "none";
              };
              # characters = { };
            };
          };
          keys = {
            normal = {
              n = ["search_next" "align_view_center"];
              N = ["search_prev" "align_view_center"];
              Z = {
                Q = ":quit!";
                Z = ":write-quit!";
              };
            };
            # picker = {
            #   "C-j" = "next_entry";
            #   "C-k" = "previous_entry";
            # };
          };
        };
        themes = {
          gruvbox_dark = let
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
            red1 = "#fb4934";
            green1 = "#b8bb26";
            yellow1 = "#fabd2f";
            blue1 = "#83a598";
            purple1 = "#d3869b";
            aqua1 = "#8ec07c";
            gray1 = "#928374";
            orange1 = "#fe8019";
            red0 = "#cc241d";
            green0 = "#98971a";
            yellow0 = "#d79921";
            blue0 = "#458588";
            purple0 = "#b16286";
            aqua0 = "#689d6" r;
            gray0 = "#a89984";
            orange0 = "#d65d0e";
          in {
            # Syntax Highlighting
            "comment" = {
              fg = gray1;
              modifiers = ["italic"];
            };
            "constant" = {
              fg = purple1;
            };
            "constant.builtin" = {
              fg = purple1;
              modifiers = ["bold"];
            };
            "constant.character.escape" = {
              fg = fg2;
              modifiers = ["bold"];
            };
            "constant.numeric" = purple1;
            "constructor" = {
              fg = purple1;
              modifiers = ["bold"];
            };
            "diff.plus" = green1;
            "diff.minus" = red1;
            "diff.delta" = orange1;
            "diff.delta.moved" = aqua1;
            "function" = {
              fg = green1;
              modifiers = ["bold"];
            };
            "function.builtin" = yellow1;
            "function.macro" = aqua1;
            "keyword" = {
              fg = red1;
            };
            "keyword.directive" = red0;
            "label" = aqua1;
            "markup.heading" = aqua1;
            "markup.bold" = {
              modifiers = ["bold"];
            };
            "markup.italic" = {
              modifiers = ["italic"];
            };
            "markup.link.url" = {
              fg = green1;
              modifiers = ["underlined"];
            };
            "markup.link.text" = red1;
            "markup.raw" = red1;
            "namespace" = aqua1;
            "operator" = purple1;
            "punctuation" = orange1;
            "punctuation.delimiter" = orange1;
            "string" = green1;
            "tag" = red1;
            "type" = yellow1;
            "type.builtin" = yellow1;
            "variable" = fg1;
            "variable.builtin" = orange1; # i.e. self, this, super
            "variable.other.member" = blue1; # i.e. structs, unions
            "variable.parameter" = fg2;

            # "constant.builtin.boolean" "constant.numeric[ .integer .float ]"
            # "comment[ .line .block[ .documentation ]]"
            # "function[ .method .special ]"
            # "keyword[ .control[ .conditional .repeat .import .return .exception ] .operator .function ]"
            # "markup[ .heading[ .marker .1-6 ] .list[ .unnumbered .numbered ] .link[ .label ] .quote .raw[ .inline .block ] ]"
            # "punctuation.bracket"
            # "string.regexp" "string.special[ .path .url .symbol ]"
            # "variable.function"

            # Helix Interface
            # "markup[ .heading[ .completion .hover ] .normal[ .completion .hover ] .raw[ inline[ .completion .hover ] ] ] ]"

            "attribute" = aqua1;
            "module" = aqua1;
            "special" = purple0;

            # Gutter
            "error" = {
              bg = bg0_hard;
              fg = red1;
            };
            "hint" = {
              bg = bg0_hard;
              fg = blue1;
            };
            "info" = {
              bg = bg0_hard;
              fg = aqua1;
            };
            "warning" = {
              bg = bg0_hard;
              fg = orange1;
            };

            # Editing Area
            "diagnostic" = {
              modifiers = ["underlined"];
            };
            "diagnostic.error" = {
              bg = bg0_hard;
              fg = red1;
            };
            "diagnostic.hint" = {
              bg = bg0_hard;
              fg = yellow1;
            };
            "diagnostic.info" = {
              bg = bg0_hard;
              fg = aqua1;
            };
            "diagnostic.warning" = {
              bg = bg0_hard;
              fg = orange1;
            };

            "ui.background" = {
              bg = bg0_hard;
            };
            "ui.background.separator" = {
              # line beneath picker input
              fg = bg4;
            };
            # "ui.cursor"
            "ui.cursor.insert" = {
              fg = blue1;
            };
            "ui.cursor.match" = {
              bg = bg3;
            };
            "ui.cursor.primary" = {
              modifiers = ["reversed"];
            };
            "ui.cursor.select" = {
              bg = gray1;
              fg = gray1;
            };
            "ui.help" = {
              bg = bg0;
              fg = fg1;
            };
            "ui.linenr" = {
              fg = bg3;
            };
            "ui.linenr.selected" = {
              fg = yellow1;
            };
            "ui.menu" = {
              bg = bg1;
              fg = fg2;
            };
            "ui.menu.selected" = {
              bg = blue1;
              fg = bg1;
              modifiers = ["bold"];
            };
            "ui.popup" = {
              bg = bg1;
            };
            "ui.popup.info" = {
              bg = bg0;
            };
            "ui.selection" = {
              bg = bg3;
            };
            "ui.selection.primary" = {
              bg = bg3;
            };
            "ui.statusline" = {
              bg = bg1;
              fg = fg4;
            };
            "ui.statusline.inactive" = {
              bg = bg0;
              fg = gray1;
            };
            "ui.text" = {
              fg = fg1;
            };
            "ui.text.info" = {
              fg = fg1;
            };
            "ui.text.focus" = {
              fg = purple1;
            };
            "ui.virtual.ruler" = {
              bg = bg0;
            };
            "ui.window" = {
              bg = bg0;
              fg = bg1;
            };
          };
        };
      };
    };
  };
}
