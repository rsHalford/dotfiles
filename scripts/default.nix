{ pkgs, lib }:
let
  screenshotTools = with pkgs; writeScriptBin "screenshot" ''
    #!${runtimeShell}
    saveLocation=$HOME/Media/Pictures/Screenshots/"$(date +%F_%H:%M:%S).png"
    grim -g "$(slurp)" -t png -l 0 "$saveLocation" &&
    wl-copy "$saveLocation" &&
    notify-send "Grim" "Screenshot Taken\n$(wl-paste)"
  '';

  sysTools = with pkgs; writeScriptBin "sys" ''
    #!${runtimeShell}
    case $1 in
        "apply")
            cd ~/.dotfiles || exit
            if [ -z "$2" ]; then
                nixos-rebuild switch --use-remote-sudo --flake '.#'
            elif [ "$2" = "--user" ] || [ "$2" = "-u" ] ; then
                nix build --impure .#homeManagerConfigurations."''${USER}".activationPackage
                ./result/activate
            elif [ "$2" = "--all" ] || [ "$2" = "-a" ] ; then
                nixos-rebuild switch --use-remote-sudo --flake '.#'
                nix build --impure .#homeManagerConfigurations."''${USER}".activationPackage
                ./result/activate
            elif [ "$2" = "--boot" ] || [ "$2" = "-b" ] ; then
                nixos-rebuild boot --use-remote-sudo --flake '.#'
            elif [ "$2" = "--test" ] || [ "$2" = "-t" ] ; then
                nixos-rebuild test --use-remote-sudo --flake '.#'
            elif [ "$2" = "--check" ] || [ "$2" = "-c" ] ; then
                nixos-rebuild dry-activate --use-remote-sudo --flake '.#'
            else
                echo "Unknown option: $2"
            fi
            cd - || exit
        ;;

        "clean")
            printf "%s\n" "Performing garbage collection on store"
            nix store gc
            printf "%s\n" "Replacing identical files in the store by hard links"
            nix store optimise
        ;;

        "depends")
            nix-store -qR "$(which "$2")"
        ;;

        "pkgs")
            nix-store -qR /run/current-system | sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq
        ;;

        "update")
            cd ~/.dotfiles || exit
            nix flake update
            # --commit-lock-file --commit-lockfile-summary "Custom Commit Message"
            cd - || exit
        ;;

        "which")
            nix show-derivation "$(which "$2")" | jq -r '.[].outputs.out.path'
        ;;

        "help"|*)
            COMMANDS="apply
    clean
    depends
    pkgs
    update
    which"

            DESCRIPTIONS="Applies current system configuration defined in dotfiles.
    Runs garbage collection and creates hard-links within nix store.
    Lists dependencies for package.
    Lists all installed packages in nix store.
    Updates the dotfiles flake.lock.
    Returns the path of the given command."

            printf "%s\n" "Usage: sys [COMMAND] [OPTIONS]"
            printf "%s\n\n" "Utility tool to manage your NixOS system"
            printf "%s\n" "Commands:"
            paste <(printf %s "$COMMANDS") <(printf %s "$DESCRIPTIONS")
        ;;
    esac
  '';

  wallpaperTools = with pkgs; writeScriptBin "bing-wp" ''
    #!${runtimeShell}
    bing="http://www.bing.com"
    xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-WW"
    saveDir=$XDG_CACHE_HOME'/bing-wp/'
    mkdir -p "$saveDir"
    picName="bing.jpg"
    picURL=$bing$(printf '%s\n' "$(curl -s "$xmlURL")" | grep -oP "<url>(.*)</url>" | cut -d ">" -f2 | cut -d "<" -f1)
    curl -s -o "$saveDir""$picName" "$picURL"
    exit
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
    scripts.sysTools = sysTools;
    scripts.wallpaperTools = wallpaperTools;
    scripts.worktreeTools = worktreeTools;
  });
}
