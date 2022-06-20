{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.development.helix;
in
{
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
        settings = {
          theme = "gruvbox";
          editor = {
            auto-completion = true;
            auto-format = true;
            auto-info = true;
            completion-trigger-len = 2;
            gutters = [ "diagnostics" "line-numbers" ];
            idle-timeout = 0;
            line-number = "relative";
            lsp.display-messages = true;
            middle-click-paste = true;
            mouse = true;
            rulers = [ 80 120 ];
            scroll-lines = 2;
            scrolloff = 8;
            shell = [ "sh" "-c" ];
            true-color = true;
            auto-pairs = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "block";
            };
            file-picker = {
              git-exclude = true;
              git-global = true;
              git-ignore = true;
              hidden = false;
              ignore = true;
              # max-depth = None;
              parents = true;
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
              space = {
                space = "file_picker";
              };
            };
          };
        };
      };
    };
  };
}
