{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.direnv;
in
{
  options.richard.direnv = {
    enable = mkOption {
      description = "Enable direnv";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs.direnv = {
      config = {
        global = {
          load_dotenv = true;
        };
      };
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib = ''
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n ${config.xdg.cacheHome}/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
                                               )}"
        }

        layout_postgres() {
            export PGDIR="$(direnv_layout_dir)/postgres"
            export PGHOST="$PGDIR"
            export PGDATA="$PGDIR/data"
            export PGLOG="$PGDIR/log"
            export PGCONF="$PGDATA/postgresql.conf"

            if [ ! -d "$PGDIR" ]; then
                mkdir -p "$PGDIR"
            fi

            if [ ! -d "$PGDATA" ]; then
                printf "%s\n" "Initialising postgresql database..."
                initdb
                printf "%s\n%s'%s'\n" "listen_addresses = '''" "unix_socket_directories = " $PGHOST >> $PGCONF
                printf '%s%s%s\n' 'CREATE DATABASE ' $USER ';' | postgres --single -E postgres
            fi
        }
      '';
    };
  };
}
