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
        theme = ./rose-pine-moon.rafi;
      };
    };
  };
}
