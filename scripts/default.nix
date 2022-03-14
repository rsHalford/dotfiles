{ pkgs, lib }:
let
  screenshotTools = with pkgs; writeScriptBin "screenshot" ''
    #!${runtimeShell}
    saveLocation=$HOME/Media/Pictures/Screenshots/"$(date +%F_%H:%M:%S).png"
    grim -g "$(slurp)" -t png -l 0 "$saveLocation" &&
    wl-copy "$saveLocation" &&
    notify-send "Grim" "Screenshot Taken\n$(wl-paste)"
  '';
in
{
  overlay = (final: prev: {
    scripts.screenshotTools = screenshotTools;
  });
}
