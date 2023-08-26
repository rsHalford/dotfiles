{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.media;
  monospace = config.richard.fonts.monospace.name;
  terminal-editor = config.richard.terminal.utilities.editor;
in {
  imports = [~/.dotfiles/secrets/newsboat];

  options.richard.media = {
    enable = mkOption {
      description = "Enable media applications";
      type = types.bool;
      default = false;
    };

    newsboat.enable = mkOption {
      description = "Enable newsboat RSS reader";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      file."${config.xdg.configHome}/whipper/whipper.conf".text = ''
        [drive:HL-DT-ST%#ADVDRAM%20GP60NB60%20%3ARF01]
        vendor = HL-DT-ST
        model = DVDRAM GP60NB60
        release = RF01
        read_offset = 6
        defeats_cache = False

        [whipper.cd.rip]
        prompt = False
        unknown = False
        cover_art = complete
        logger = whipper
        output_directory = ~/media/music/
        working_directory = ~/media/music/
        track_template = %%A/%%d/%%t. %%a - %%n
        disc_template = %%A/%%d/%%A - %%d
      '';
      packages = with pkgs; [
        calibre
        ffmpeg
        imv
        mpc-cli
        newsboat
        scripts.ytTools
        streamlink
        toot
        whipper
        ytfzf
      ];
    };
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
          keep-open = "yes";
          ytdl-format = "bestvideo[height<=?720]+bestaudio/best";
          ytdl-raw-options = "ignore-config=,sub-lang=en,write-sub=,write-auto-sub=";
          slang = "en";
          sub-auto = "fuzzy";
          osd-font = "${monospace} Nerd Font";
          osd-font-size = 20;
          osc = "no";
          osd-bar = "no";
          border = "no";
        };
        defaultProfiles = [];
        profiles = {};
        # TODO: figure out why mpv doesn't the youtube-quality and thumbnail scripts
        scripts = with pkgs; [
          mpvScripts.mpris
          mpvScripts.uosc
          mpvScripts.thumbfast
          mpvScripts.sponsorblock
        ];
      };
      ncmpcpp = {
        enable = true;
        package = pkgs.ncmpcpp.override {visualizerSupport = true;};
        bindings = [
          {
            key = "j";
            command = "scroll_down";
          }
          {
            key = "shift-down";
            command = ["select_item" "scroll_down"];
          }
          {
            key = "k";
            command = "scroll_up";
          }
          {
            key = "shift-up";
            command = ["select_item" "scroll_up"];
          }
          {
            key = "ctrl-u";
            command = "page_up";
          }
          {
            key = "ctrl-d";
            command = "page_down";
          }
          {
            key = "h";
            command = "previous_column";
          }
          {
            key = "l";
            command = "next_column";
          }
          {
            key = "L";
            command = "show_lyrics";
          }
          {
            key = "alt-f";
            command = "toggle_lyrics_fetcher";
          }
          {
            key = "n";
            command = "next_found_item";
          }
          {
            key = "N";
            command = "previous_found_item";
          }
          {
            key = "J";
            command = "move_sort_order_down";
          }
          {
            key = "K";
            command = "move_sort_order_up";
          }
          {
            key = "h";
            command = "jump_to_parent_directory";
          }
          {
            key = "l";
            command = "enter_directory";
          }
          {
            key = "l";
            command = "run_action";
          }
          {
            key = "l";
            command = "play_item";
          }
          {
            key = "m";
            command = "toggle_media_library_columns_mode";
          }
          {
            key = "g";
            command = "move_home";
          }
          {
            key = "G";
            command = "move_end";
          }
          {
            key = "b";
            command = "change_browse_mode";
          }
          {
            key = "d";
            command = "delete_playlist_items";
          }
          {
            key = ".";
            command = "seek_forward";
          }
          {
            key = ",";
            command = "seek_backward";
          }
          {
            key = "ctrl-v";
            command = "select_range";
          }
          {
            key = "V";
            command = "remove_selection";
          }
          {
            key = "ctrl-k";
            command = "move_selected_items_up";
          }
          {
            key = "ctrl-j";
            command = "move_selected_items_down";
          }
        ];
        mpdMusicDir = null;
        settings = {
          ncmpcpp_directory = "~/.config/ncmpcpp";
          lyrics_directory = "~/.local/share/lyrics";
          mpd_music_dir = "~/media/music";
          default_place_to_search_in = "database";
          mpd_crossfade_time = "3";
          visualizer_data_source = "/tmp/mpd.fifo";
          visualizer_output_name = "ncmpcpp visualizer";
          visualizer_in_stereo = "yes";
          visualizer_type = "spectrum";
          visualizer_look = "⏺⏺";
          visualizer_fps = "144";
          visualizer_spectrum_smooth_look = "no";
          visualizer_spectrum_dft_size = "1";
          visualizer_spectrum_gain = "10";
          playlist_disable_highlight_delay = "5";
          playlist_shorten_total_times = "yes";
          ask_before_clearing_playlists = "yes";
          song_list_format = "{{$4%30t$9}{$8 - $6%30a$9}{$8 - %30b$9}}|{$4%90f$9}$R{$(blue)%l$9}";
          song_status_format = "{{$4\"%t\"$9}{ $8by$6 %a$9}{$8 - %b$9}}|{$4%f$9}";
          song_columns_list_format = "(30)[magenta]{a} (30)[yellow]{t} (30)[white]{b} (10)[blue]{l}";
          alternative_header_first_line_format = "$0$aqqu$/a{$4%t$9}|{$4%f$9} $0$atqq$/a$9";
          alternative_header_second_line_format = "{$6%a$8}{$8 - %b$9}";
          mouse_support = "no";
          current_item_prefix = "$(magenta)$r$b";
          current_item_suffix = "$/r$(end)$/b";
          current_item_inactive_column_prefix = "$(blue)$r";
          current_item_inactive_column_suffix = "$/r$(end)";
          now_playing_prefix = "⏵ ";
          jump_to_now_playing_song_at_start = "yes";
          centered_cursor = "yes";
          incremental_seeking = "yes";
          seek_time = "1";
          progressbar_look = "=>-";
          playlist_editor_display_mode = "columns";
          playlist_display_mode = "columns";
          search_engine_display_mode = "columns";
          browser_display_mode = "columns";
          display_bitrate = "no";
          display_volume_level = "yes";
          enable_window_title = "yes";
          empty_tag_marker = "";
          regular_expressions = "extended";
          ignore_leading_the = "yes";
          ignore_diacritics = "yes";
          autocenter_mode = "yes";
          cyclic_scrolling = "yes";
          lines_scrolled = "1";
          colors_enabled = "yes";
          header_window_color = "white";
          main_window_color = "white";
          player_state_color = "cyan";
          volume_color = "cyan";
          statusbar_color = "white";
          progressbar_elapsed_color = "green";
          progressbar_color = "white";
          discard_colors_if_item_is_selected = "yes";
          follow_now_playing_lyrics = "yes";
          fetch_lyrics_for_current_song_in_background = "yes";
          external_editor = "${terminal-editor}";
          use_console_editor = "yes";
          header_visibility = "yes";
          statusbar_visibility = "yes";
          titles_visibility = "yes";
        };
      };
      newsboat = {
        enable = cfg.newsboat.enable;
        autoReload = true;
        maxItems = 0; # infinite
        reloadThreads = 5;
        reloadTime = 120;
        extraConfig = ''
          # General
          show-read-articles no
          show-read-feeds no
          delete-read-articles-on-quit no
          player "mpv --no-video %u"
          datetime-format "%Y-%m-%d %a"
          article-sort-order date-desc
          save-path ~/.local/share/newsboat/saved/
          download-path ~/media/music/podcasts/
          macro v set browser "setsid -f umpv" ; open-in-browser ; set browser "${pkgs.xdg-utils}/bin/xdg-open";

          # Keys
          bind-key ; macro-prefix
          bind-key j down
          bind-key k up
          bind-key j next articlelist
          bind-key k prev articlelist
          bind-key J next-feed articlelist
          bind-key K prev-feed articlelist
          bind-key G end
          bind-key g home
          bind-key d pagedown
          bind-key u pageup
          bind-key l open
          bind-key h quit
          bind-key a toggle-article-read
          bind-key n next-unread
          bind-key N prev-unread
          bind-key D pb-download
          bind-key U show-urls
          bind-key x pb-delete
          bind-key r reload
          bind-key R reload-all

          # Colours
          color listnormal white default
          color listfocus default default bold
          color listnormal_unread cyan default
          color listfocus_unread yellow default bold
          color info white default bold
          color article white default
        '';
      };
    };
  };
}
