{
  pkgs,
  lib,
}: let
  screenshotTools = with pkgs;
    writeScriptBin "screenshot" ''
      #!${runtimeShell}
      saveLocation=$HOME/media/pictures/screenshots/"$(date +%FT%H-%M-%S).png"
      grim -g "$(slurp)" -t png -l 0 "$saveLocation" &&
      wl-copy "$saveLocation" &&
      notify-send "Grim" "Screenshot Taken\n$(wl-paste)"
    '';

  sysTools = with pkgs;
    writeScriptBin "sys" ''
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
              printf "%s\n" "Deleting old system generations"
              sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5
              printf "%s\n" "Deleting old user generations"
              nix-env --delete-generations +5
              printf "%s\n" "Performing garbage collection on store"
              nix store gc
              printf "%s\n" "Replacing identical files in the store by hard links"
              nix store optimise
          ;;

          "depends")
              nix-store -qR "$(which "$2")"
          ;;

          "gens")
              if [ -z "$2" ]; then
                  sudo nix-env -p /nix/var/nix/profiles/system --list-generations
              elif [ "$2" = "--user" ] || [ "$2" = "-u" ] ; then
                  nix-env --list-generations
              else
                  echo "Unknown option: $2"
              fi
          ;;

          "pkgs")
              nix-store -qR /run/current-system | \
              sed -n -e 's/\/nix\/store\/[0-9a-z]\{32\}-//p' | sort | uniq
          ;;

          "search")
              nix search nixpkgs --json "''${@:2}" | \
              sed 's/^//' | \
              jq -r '.[] | "\(.pname)\t\(.description)"' | \
              column -t -s "$(printf '\t')" | \
              rg -S --color always "$2"
          ;;

          "update")
              cd ~/.dotfiles || exit
              nix flake update
              # --commit-lock-file --commit-lockfile-summary "Custom Commit Message"
              cd - || exit
          ;;

          "which")
              nix derivation show "$(which "$2")" | \
              jq -r '.[].outputs.out.path'
          ;;

          "help"|*)
              COMMANDS="apply
      clean
      depends
      gens
      pkgs
      search
      update
      which"

              OPTIONS="<argument>


      <argument>
      <package> -e <pattern>

      <package>"

              DESCRIPTIONS="Applies current system configuration defined in dotfiles.
      Runs garbage collection and creates hard-links within nix store.
      Lists dependencies for package.
      Lists configuration generations for both the system and user.
      Lists all installed packages in nix store.
      Searches in nixpkgs for a package using the provided arguments.
      Updates the dotfiles flake.lock.
      Returns the path of the given command."

              printf "%s\n" "Usage: sys [COMMAND] [OPTIONS]"
              printf "%s\n\n" "Utility tool to manage your NixOS system"
              printf "%s\n" "Commands:"
              paste <(printf %s "$COMMANDS") <(printf %s "$OPTIONS") <(printf %s "$DESCRIPTIONS") | \
              column -t -s "$(printf '\t')"
          ;;
      esac
    '';

  bingTools = with pkgs;
    writeScriptBin "bing-wp" ''
      #!${runtimeShell}
      bing="http://www.bing.com"
      xmlURL="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-WW"
      saveDir=$XDG_CACHE_HOME'/bing-wp/'
      ${coreutils}/bin/mkdir -p "$saveDir"
      picName="bing.jpg"
      picURL=$bing$(${coreutils}/bin/printf '%s\n' "$(${curl}/bin/curl -s "$xmlURL")" | ${gnugrep}/bin/grep -oP "<url>(.*)</url>" | ${coreutils-full}/bin/cut -d ">" -f2 | ${coreutils-full}/bin/cut -d "<" -f1)
      ${curl}/bin/curl -s -o "$saveDir""$picName" "$picURL"
      exit
    '';

  wallpaperTools = with pkgs;
    writeScriptBin "random-wallpaper" ''
      #!${runtimeShell}
      if [ -S /run/user/1000/swww.socket ]; then
        swww kill &> /dev/null
      fi
      if [ -d ~/.cache/swww ]; then
        rm -r ~/.cache/swww &> /dev/null
      fi
      swww init && watch -n 600 "${swww}/bin/swww img ""$(find ~/.dotfiles/wallpapers -type f | shuf -n 1)"" &> /dev/null"
    '';

  worktreeTools = with pkgs;
    writeScriptBin "worktree-clone" ''
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
    '';

  ytTools = with pkgs;
    writeScriptBin "ytfuzzy" ''
      #!${runtimeShell}
      VID=$(ytfzf -L -T "$IMAGE" -t "$1")
      PID=$(pidof mpv)
      if [ -z "$PID" ]
      then
        umpv "$VID" &
      else
        umpv "$VID"
      fi
    '';

  mpvTools = with pkgs;
    writeScriptBin "browser2mpv" ''
      #!${runtimeShell}
      case "$XDG_CURRENT_DESKTOP" in
        "sway")
          FOCUS=$(${sway}/bin/swaymsg -t get_tree | jq -r '..|try select(.focused == true)' | jq ."app_id")
        ;;
        "Hyprland")
          FOCUS=$(${hyprland}/bin/hyprctl activewindow -j | jq .class)
        ;;
        *)
          ${libnotify}/bin/notify-send "Unsupported desktop" "Currently in $XDG_CURRENT_DESKTOP" -t 2000
        ;;
      esac
      PID=$(${procps}/bin/pidof mpv)
      TIME="0.8"
      case "$FOCUS" in
        *"$BROWSER"*)
          ${wtype}/bin/wtype yy
          ${coreutils}/bin/sleep "$TIME"
          URL="$(${wl-clipboard}/bin/wl-paste)"
          ${libnotify}/bin/notify-send "Added to MPV Playlist" -t 2000
          if [ -z "$PID" ]
          then
            umpv "$URL" &
          else
            umpv "$URL"
          fi
        ;;
        *)
          ${libnotify}/bin/notify-send "$BROWSER not focussed" "Current focus $FOCUS" -t 2000
        ;;
      esac
    '';

  tmuxTools = with pkgs;
    writeScriptBin "tmux-sessioniser" ''
      #!${runtimeShell}
      if [[ $# -eq 1 ]]; then
          SELECTED=$1
      else
          SELECTED=$(find ~/projects -mindepth 1 -maxdepth 1 -type d | fzf)
      fi

      if [[ -z $SELECTED ]]; then
          exit 0
      fi

      SELECTED_NAME=$(basename "$SELECTED" | tr . _)
      TMUX_RUNNING=$(pgrep tmux)

      if [[ -z $TMUX ]] && [[ -z $TMUX_RUNNING ]]; then
          tmux new-session -s $SELECTED_NAME -c $SELECTED
          exit 0
      fi

      if ! tmux has-session -t=$SELECTED_NAME 2> /dev/null; then
          tmux new-session -ds $SELECTED_NAME -c $SELECTED
      fi

      tmux switch-client -t $SELECTED_NAME
    '';
in {
  overlay = final: prev: {
    scripts.screenshotTools = screenshotTools;
    scripts.sysTools = sysTools;
    scripts.bingTools = bingTools;
    scripts.wallpaperTools = wallpaperTools;
    scripts.worktreeTools = worktreeTools;
    scripts.ytTools = ytTools;
    scripts.mpvTools = mpvTools;
    scripts.tmuxTools = tmuxTools;
  };
}
