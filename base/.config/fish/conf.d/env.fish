set -gx PATH "$PATH" "$HOME/.local/bin" "$HOME/.local/share/appimages" /var/lib/flatpak/exports/bin "$HOME/.local/state/nix/profile/bin" "$HOME/.local/share/mix/escripts" "$HOME/.local/share/go/bin" "$HOME/.local/share/gem/bin" "$HOME/.local/share/cargo/bin"

set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"

set -gx XDG_DESKTOP_DIR "$HOME/desktop"
set -gx XDG_DOCUMENTS_DIR "$HOME/documents"
set -gx XDG_DOWNLOAD_DIR "$HOME/downloads"
set -gx XDG_MUSIC_DIR "$HOME/media/music"
set -gx XDG_PICTURES_DIR "$HOME/media/pictures"
set -gx XDG_PUBLICSHARE_DIR "$HOME/public"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_TEMPLATES_DIR "$HOME/templates"
set -gx XDG_VIDEOS_DIR "$HOME/media/videos"

set -gx DOTFILES_DIR "$HOME/.dotfiles"
set -gx PROJECTS_DIR "$HOME/projects"
set -gx SOURCES_DIR "$HOME/sources"
set -gx WORK_DIR "$HOME/work"

set -gx ADB_KEYS_PATH "$ANDROID_PREFS_ROOT"
set -gx ADB_VENDOR_KEY "$ANDROID_PREFS_ROOT"
set -gx ANDROID_AVD_HOME "$XDG_DATA_HOME/android/"
set -gx ANDROID_EMULATOR_HOME "$XDG_DATA_HOME/android/emulator"
set -gx ANDROID_PREFS_ROOT "$XDG_CONFIG_HOME/android"
set -gx ANDROID_SDK_HOME "$XDG_DATA_HOME/android/"
set -gx BUNDLE_USER_CACHE "$XDG_CACHE_HOME/bundle"
set -gx BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME/bundle"
set -gx BUNDLE_USER_PLUGIN "$XDG_DATA_HOME/bundle"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx FZF_DEFAULT_OPTS -i
set -gx GEM_HOME "$XDG_DATA_HOME/gem"
set -gx GEM_SPEC_CACHE "$XDG_CACHE_HOME/gem"
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx HISTFILE "$XDG_CACHE_HOME/history"
set -gx JAVA_FONTS /usr/share/fonts/TTF
set -gx LESSHISTFILE -
set -gx MIX_XDG true
set -gx NODE_REPL_HISTORY "$XDG_CACHE_HOME/history/node_repl_history"
set -gx NOTMUCH_CONFIG "$XDG_CONFIG_HOME/notmuch-config"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx PARALLEL_HOME "$XDG_CONFIG_HOME/parallel"
set -gx PASSWORD_STORE_DIR "$XDG_DATA_HOME/password-store"
set -gx PYLINTHOME "$XDG_CACHE_HOME/pylint"
set -gx PYTHON_HISTORY "$XDG_STATE_HOME/python/history"
set -gx PYTHONPYCACHEPREFIX "$XDG_CACHE_HOME/python"
set -gx PYTHONUSERBASE "$XDG_DATA_HOME/python"
set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/config"
set -gx SQLITE_HISTORY "$XDG_CACHE_HOME/sqlite_history"
set -gx WGETRC "$XDG_CONFIG_HOME/wgetrc"

set -gx BROWSER brave
set -gx EDITOR helix
set -gx MANPAGER "nvim +Man!"
set -gx TERM ghostty
set -gx VISUAL helix
