{ pkgs, lib }:
let
  screenshotTools = with pkgs; writeScriptBin "screenshot" ''
    #!${runtimeShell}
    saveLocation=$HOME/Media/Pictures/Screenshots/"$(date +%F_%H:%M:%S).png"
    grim -g "$(slurp)" -t png -l 0 "$saveLocation" &&
    wl-copy "$saveLocation" &&
    notify-send "Grim" "Screenshot Taken\n$(wl-paste)"
  '';

  worktreeTools = with pkgs; writeScriptBin "worktree-clone" ''
    #!${runtimeShell}
    URL=$1
    BASENAME=''${URL##*/}
    NAME=''${2:-''${BASENAME%.*}}
    mkdir "$NAME"
    cd "$NAME" || exit
    git clone --bare "$URL" .bare
    echo "gitdir: ./.bare" > .git
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin
    cd - || exit
  '';
in
{
  overlay = (final: prev: {
    scripts.screenshotTools = screenshotTools;
    scripts.worktreeTools = worktreeTools;
  });
}
