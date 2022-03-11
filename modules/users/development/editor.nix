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
    programs = {
      neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
	# extraConfig = "";
	# extraLuaPackages = "[]";
	# extraPackages = with pkgs; = [ ];
	# extraPython3Packages = "ps: []";
	# generatedConfigViml = "";
	# plugins = [ ];
	# viAlias = true;
	# vimAlias = true;
	# vimdiffAlias = true;
	# withNodeJs = true;
	# with Python3 = true;
	# withRuby = true;
      };
    };
  };
}
