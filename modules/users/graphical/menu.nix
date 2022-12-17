{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.graphical.menu;
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
          modi = "run,drun,ssh,filebrowser,calc,keys"; # custom mode <name>:<script>
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
          # terminal = "\${pkgs.alacritty}/bin/alacritty";
          kb-row-down = "Down,Control+j";
          kb-row-up = "Up,Control+k";
          kb-accept-entry = "Control+m,Return,KP_Enter";
          kb-remove-to-eol = "";
        };
        plugins = with pkgs; [
          rofi-calc
        ];
        theme = {
           "*" = {
              bg = mkLiteral "#232136";
              cur = mkLiteral "#393552";
              fgd = mkLiteral "#e0def4";
              blu = mkLiteral "#817c9c";
              cya = mkLiteral "#9ccfd8";
              grn = mkLiteral "#3e8fb0";
              ora = mkLiteral "#ea9a97";
              pur = mkLiteral "#c4a7e7";
              red = mkLiteral "#eb6f92";
              yel = mkLiteral "#f6c177";
              foreground = mkLiteral "var(fgd)";
              background = mkLiteral "var(bg)";
              active-background = mkLiteral "var(grn)";
              urgent-background = mkLiteral "var(red)";
              selected-background = mkLiteral "var(active-background)";
              selected-urgent-background = mkLiteral "var(urgent-background)";
              selected-active-background = mkLiteral "var(active-background)";
              separatorcolor = mkLiteral "var(active-background)";
              bordercolor = mkLiteral "var(ora)";
          };
          "#window" = {
              background-color = mkLiteral "var(background)";
              border = mkLiteral "3";
              border-radius = mkLiteral "6";
              border-color = mkLiteral "var(bordercolor)";
              padding = mkLiteral "5";
          };
          "#mainbox" = {
              border = mkLiteral "0";
              padding = mkLiteral "5";
          };
          "#message" = {
              border = mkLiteral "1px dash 0px 0px";
              border-color = mkLiteral "var(separatorcolor)";
              padding = mkLiteral "1px";
          };
          "#textbox" = {
              text-color = mkLiteral "var(foreground)";
          };
          "#listview" = {
              fixed-height = mkLiteral "0";
              border = mkLiteral "2px dash 0px 0px";
              border-color = mkLiteral "var(bordercolor)";
              spacing = mkLiteral "2px";
              scrollbar = mkLiteral "false";
              padding = mkLiteral "2px 0px 0px";
          };
          "#element" = {
              border = mkLiteral "0";
              padding = mkLiteral "1px";
          };
          "#element normal.normal" = {
              background-color = mkLiteral "var(background)";
              text-color = mkLiteral "var(foreground)";
          };
          "#element normal.urgent" = {
              background-color = mkLiteral "var(urgent-background)";
              text-color = mkLiteral "var(foreground)";
          };
          "#element normal.active" = {
              background-color = mkLiteral "var(active-background)";
              text-color = mkLiteral "var(background)";
          };
          "#element selected.normal" = {
              background-color = mkLiteral "var(selected-background)";
              text-color = mkLiteral "var(foreground)";
          };
          "#element selected.urgent" = {
              background-color = mkLiteral "var(selected-urgent-background)";
              text-color = mkLiteral "var(foreground)";
          };
          "#element selected.active" = {
              background-color = mkLiteral "var(selected-active-background)";
              text-color = mkLiteral "var(background)";
          };
          "#element alternate.normal" = {
              background-color = mkLiteral "var(background)";
              text-color = mkLiteral "var(foreground)";
          };
          "#element alternate.urgent" = {
              background-color = mkLiteral "var(urgent-background)";
              text-color = mkLiteral "var(foreground)";
          };
          "#element alternate.active" = {
              background-color = mkLiteral "var(active-background)";
              text-color = mkLiteral "var(foreground)";
          };
          "#scrollbar" = {
              width = mkLiteral "2px";
              border = mkLiteral "0";
              handle-width = mkLiteral "8px";
              padding = mkLiteral "0";
          };
          "#sidebar" = {
              border = mkLiteral "2px dash 0px 0px";
              border-color = mkLiteral "var(separatorcolor)";
          };
          "#button.selected" = {
              background-color = mkLiteral "var(selected-background)";
              text-color = mkLiteral "var(foreground)";
          };
          "#inputbar" = {
              spacing = mkLiteral "0";
              text-color = mkLiteral "var(foreground)";
              padding = mkLiteral "1px";
          };
          "#case-indicator" = {
              spacing = mkLiteral "0";
              text-color = mkLiteral "var(foreground)";
          };
          "#entry" = {
              spacing = mkLiteral "0";
              text-color = mkLiteral "var(cya)";
          };
          "#prompt" = {
              spacing = mkLiteral "0";
              text-color = mkLiteral "var(grn)";
          };
          "#inputbar" = {
              children = map mkLiteral [ "prompt" "textbox-prompt-colon" "entry" "case-indicator" ];
          };
          "#textbox-prompt-sep" = {
              expand = mkLiteral "false";
              str = ":";
              margin = mkLiteral "0px 2px";
              text-color = mkLiteral "var(grn)";
          };
        };
      };
    };
  };
}
