{ pkgs, config, lib, ...}:
with lib;

let
  cfg = config.richard.development.editor;
in
{
  options.richard.development.editor = {
    enable = mkOption {
      description = "Enable development editor";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      neovim
    ];
    programs = {
      # neovim.enable = true;
    };
  };
}
