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
        };
        pass = {
          enable = true;
          # extraConfig = "";
          # stores = [ ];
        };
        plugins = with pkgs; [
          rofi-calc
        ];
        theme = {
          "*" = {
            window-transparent = mkLiteral "#00000090";
            background-transparent = mkLiteral "#00000000";
            gruvbox-fg0 = mkLiteral "#fbf1c7";
            gruvbox-fg1 = mkLiteral "#ebddb2";
            gruvbox-red-dark = mkLiteral "#cc241d";
            gruvbox-red-light = mkLiteral "#fb4934";
            gruvbox-yellow-dark = mkLiteral "#d79921";
            gruvbox-yellow-light = mkLiteral "#fabd2f";
            gruvbox-blue-dark = mkLiteral "#458588";
            gruvbox-purple-dark = mkLiteral "#b16286";
            highlight = mkLiteral "bold italic";
            border-color = mkLiteral "var(gruvbox-purple-dark)";
            separatorcolor = mkLiteral "var(border-color)";
            scrollbar = mkLiteral "false";
            background = mkLiteral "var(window-transparent)";
            background-color = mkLiteral "var(background-transparent)";
            normal-background = mkLiteral "var(background-transparent)";
            active-background = mkLiteral "var(gruvbox-yellow-dark)";
            urgent-background = mkLiteral "var(gruvbox-red-dark)";
            selected-normal-background = mkLiteral "var(gruvbox-blue-dark)";
            selected-active-background = mkLiteral "var(gruvbox-yellow-ljght)";
            selected-urgent-background = mkLiteral "var(gruvbox-red-light)";
            foreground = mkLiteral "var(gruvbox-fg1)";
            normal-foreground = mkLiteral "var(foreground)";
            active-foreground = mkLiteral "var(background)";
            urgent-foreground = mkLiteral "var(background)";
            selected-normal-foreground = mkLiteral "var(gruvbox-fg0)";
            selected-active-foreground = mkLiteral "var(active-foreground)";
            selected-urgent-foreground = mkLiteral "var(urgent-foreground)";
          };
          "#window" = {
            height = mkLiteral "100%";
            width = mkLiteral "100%";
            padding = mkLiteral "30% 38%";
            background-color = mkLiteral "var(background)";
            border = mkLiteral "0";
          };
          "#mainbox" = {
            padding = mkLiteral "0";
          };
          "#message" = {
            padding = mkLiteral "4px";
            border = mkLiteral "2px";
            border-color = mkLiteral "var(separatorcolor)";
          };
          "#textbox" = {
            highlight = mkLiteral "var(highlight)";
            text-color = mkLiteral "var(foreground)";
          };
          "#inputbar" = {
            padding = mkLiteral "4px";
            spacing = mkLiteral "0";
            text-color = mkLiteral "var(normal-foreground)";
            children = map mkLiteral [ "prompt" "textbox-prompt-sep" "entry" "case-indicator" ];
            border = mkLiteral "2px";
            border-color = mkLiteral "var(separatorcolor)";
          };
          "#prompt" = {
            spacing = mkLiteral "0";
            text-color = mkLiteral "var(normal-foreground)";
          };
          "#textbox-prompt-sep" = {
            margin = mkLiteral "0px 2px";
            expand = mkLiteral "false";
            str = ":";
            text-color = mkLiteral "var(normal-foreground)";
          };
          "#entry" = {
            spacing = mkLiteral "0";
            text-color = mkLiteral "var(normal-foreground)";
          };
          "#case-indicator" = {
            spacing = mkLiteral "0";
            text-color = mkLiteral "var(normal-foreground)";
          };
          "#listview" = {
            padding = mkLiteral "0";
            scrollbar = mkLiteral "var(scrollbar)";
            spacing = mkLiteral "0";
            border = mkLiteral "0";
          };
          "#element" = {
            padding = mkLiteral "4px";
            border = mkLiteral "0";
          };
          "#element normal.normal" = {
            background-color = mkLiteral "var(normal-background)";
            text-color = mkLiteral "var(normal-foreground)";
          };
          "#element normal.urgent" = {
            background-color = mkLiteral "var(urgent-background)";
            text-color = mkLiteral "var(urgent-foreground)";
          };
          "#element normal.active" = {
            background-color = mkLiteral "var(active-background)";
            text-color = mkLiteral "var(active-foreground)";
          };
          "#element selected.normal" = {
            background-color = mkLiteral "var(selected-normal-background)";
            text-color = mkLiteral "var(selected-normal-foreground)";
          };
          "#element selected.urgent" = {
            background-color = mkLiteral "var(selected-urgent-background)";
            text-color = mkLiteral "var(selected-urgent-foreground)";
          };
          "#element selected.active" = {
            background-color = mkLiteral "var(selected-active-background)";
            text-color = mkLiteral "var(selected-active-foreground)";
          };
          "#element alternate.normal" = {
            background-color = mkLiteral "var(normal-background)";
            text-color = mkLiteral "var(normal-foreground)";
          };
          "#element alternate.urgent" = {
            background-color = mkLiteral "var(urgent-background)";
            text-color = mkLiteral "var(urgent-foreground)";
          };
          "#element alternate.active" = {
            background-color = mkLiteral "var(active-background)";
            text-color = mkLiteral "var(active-foreground)";
          };
          "#element-text" = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          "#element-icon" = {
            padding = mkLiteral "0px 4px 0px 0px";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          "#button" = {
            spacing = mkLiteral "0";
            text-color = mkLiteral "var(normal-foreground)";
          };
          "#button.selected" = {
            background-color = mkLiteral "var(selected-normal-background)";
            text-color = mkLiteral "var(selected-normal-foreground)";
          };
        };
      };
    };
  };
}
