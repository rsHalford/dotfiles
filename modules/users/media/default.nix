{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.media;
in
{
  options.richard.media = {
    enable = mkOption {
      description = "Enable media applications";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      chatterino2
      imv
    ];
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
        # TODO: figure out why mpv doesn't the youtube-quality and thumbnail scripts
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

