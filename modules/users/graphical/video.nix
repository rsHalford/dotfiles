{ pkgs, config, lib, ...}:
with lib;

let
  cfg = config.richard.graphical.video;
in
{
  options.richard.graphical.video = {
    enable = mkOption {
      description = "Enable video";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs = {
      mpv = {
        enable = true;
	bindings = {
	  "h" = "seek -20";
	  "j" = "seek -5";
	  "k" = "seek 5";
	  "l" = "seek 20";
	};
	config = {
	  ytdl-format = "bestvideo[height<=?720]+bestaudio/best";
	  osd-font = "JetBrainsMono Nerd Font";
	  osd-font-size = 20;
	  osc = "no";
	};
	defaultProfiles = [ ];
	profiles = { };
	scripts = with pkgs; [
	  mpvScripts.thumbnail
	  mpvScripts.youtube-quality
	  mpvScripts.mpv-playlistmanager
	  # mpvScripts.mppris
	];
      };
    };
  };
}

