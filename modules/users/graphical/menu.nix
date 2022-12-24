{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.graphical.menu;
  terminal = config.richard.terminal.emulator.program;
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  options.richard.graphical.menu = {
    enable = mkOption {
      description = "Enable menu";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs = {
      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        cycle = true;
        extraConfig = {
          modi = "drun,emoji,calc,ssh,filebrowser,run,keys"; # custom mode <name>:<script>
          cache-dir = "${config.xdg.cacheHome}/rofi/";
          scroll-method = 1;
          show-icons = true;
          steal-focus = true;
          matching = "fuzzy"; # regex glob
          drun-match-fields = "name,generic";
          drun-display-format = "{name}";
          hover-select = true;
          sorting-method = "fzf"; # levenshtein
          drun-url-launcher = "xdg-open";
          click-to-exit = true;
          icon-theme = "Papirus-Dark";
          font = "JetBrainsMono Nerd Font 13";
          terminal = "${pkgs.${terminal}}/bin/${terminal}";
          kb-row-down = "Down,Control+j";
          kb-row-up = "Up,Control+k";
          kb-accept-entry = "Control+m,Return,KP_Enter";
          kb-remove-to-eol = "";
        };
        plugins = with pkgs; [
          rofi-calc
          rofi-emoji
        ];
        theme = {
          "*" = {
            bg = mkLiteral "#2a273f";
            cur = mkLiteral "#393552";
            fgd = mkLiteral "#e0def4";
            blu = mkLiteral "#817c9c";
            cya = mkLiteral "#9ccfd8";
            grn = mkLiteral "#3e8fb0";
            ora = mkLiteral "#ea9a97";
            pur = mkLiteral "#c4a7e7";
            red = mkLiteral "#eb6f92";
            yel = mkLiteral "#f6c177";
            foreground = mkLiteral "@fgd";
            background = mkLiteral "@bg";
            active-background = mkLiteral "@grn";
            urgent-background = mkLiteral "@red";
            selected-background = mkLiteral "@active-background";
            selected-urgent-background = mkLiteral "@urgent-background";
            selected-active-background = mkLiteral "@active-background";
            separatorcolor = mkLiteral "@active-background";
            bordercolor = mkLiteral "@ora";
            background-color = mkLiteral "@background";
          };
          "window" = {
            background-color = mkLiteral "@background";
            border = mkLiteral "3";
            border-radius = mkLiteral "6";
            border-color = mkLiteral "@bordercolor";
            padding = mkLiteral "5";
          };
          "mainbox" = {
            border = mkLiteral "0";
            padding = mkLiteral "5";
          };
          "message" = {
            border = mkLiteral "1px dash 0px 0px";
            border-color = mkLiteral "@separatorcolor";
            padding = mkLiteral "1px";
          };
          "textbox" = {
            text-color = mkLiteral "@foreground";
          };
          "listview" = {
            fixed-height = mkLiteral "0";
            border = mkLiteral "2px dash 0px 0px";
            border-color = mkLiteral "@bordercolor";
            spacing = mkLiteral "2px";
            scrollbar = mkLiteral "false";
            padding = mkLiteral "2px 0px 0px";
          };
          "element" = {
            border = mkLiteral "0";
            padding = mkLiteral "1px";
            cursor = mkLiteral "pointer";
          };
          "element.normal.normal" = {
            background-color = mkLiteral "@background";
            text-color = mkLiteral "@foreground";
          };
          "element.normal.urgent" = {
            background-color = mkLiteral "@urgent-background";
            text-color = mkLiteral "@foreground";
          };
          "element.normal.active" = {
            background-color = mkLiteral "@active-background";
            text-color = mkLiteral "@background";
          };
          "element.selected.normal" = {
            background-color = mkLiteral "@selected-background";
            text-color = mkLiteral "@foreground";
          };
          "element.selected.urgent" = {
            background-color = mkLiteral "@selected-urgent-background";
            text-color = mkLiteral "@foreground";
          };
          "element.selected.active" = {
            background-color = mkLiteral "@selected-active-background";
            text-color = mkLiteral "@background";
          };
          "element.alternate.normal" = {
            background-color = mkLiteral "@background";
            text-color = mkLiteral "@foreground";
          };
          "element.alternate.urgent" = {
            background-color = mkLiteral "@urgent-background";
            text-color = mkLiteral "@foreground";
          };
          "element.alternate.active" = {
            background-color = mkLiteral "@active-background";
            text-color = mkLiteral "@foreground";
          };
          "element-text" = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          "element-icon" = {
            background-color = mkLiteral "inherit";
          };
          "scrollbar" = {
            width = mkLiteral "2px";
            border = mkLiteral "0";
            handle-width = mkLiteral "8px";
            padding = mkLiteral "0";
          };
          "sidebar" = {
            border = mkLiteral "2px dash 0px 0px";
            border-color = mkLiteral "@separatorcolor";
          };
          "button.selected" = {
            background-color = mkLiteral "@selected-background";
            text-color = mkLiteral "@foreground";
          };
          "inputbar" = {
            spacing = mkLiteral "0";
            text-color = mkLiteral "@foreground";
            padding = mkLiteral "1px";
            children = map mkLiteral [ "prompt" "textbox-prompt-sep" "entry" "case-indicator" ];
          };
          "case-indicator" = {
            spacing = mkLiteral "0";
            text-color = mkLiteral "@foreground";
          };
          "entry" = {
            spacing = mkLiteral "0";
            text-color = mkLiteral "@cya";
          };
          "prompt" = {
            spacing = mkLiteral "0";
            text-color = mkLiteral "@grn";
          };
          "textbox-prompt-sep" = {
            expand = mkLiteral "false";
            str = ":";
            margin = mkLiteral "0px 0.3em 0em 0em";
            text-color = mkLiteral "@grn";
          };
        };
      };
    };
  };
}
