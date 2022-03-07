{ pkgs, config, lib, ...}:
with lib;

let
  cfg = config.richard.graphical.compositor;
in
{
  options.richard.graphical.compositor = {
    enable = mkOption {
      description = "Enable compositor";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    wayland = {
      windowManager = {
        sway = {
	  enable = true;
	  config = {
	    # assigns = { }; # assigns applications to individual workspaces
	    bars = [{
	      command = "\${pkgs.waybar}/bin/waybar";
	      fonts = {
	        names = [ "JetBrainsMono Nerd Font" ];
		style = "Bold";
		size = 10.0;
	      };
	      position = "top";
	      # status_command = "i3status";
	    }];
            # bindkeysToCode = false; # use --to-code in keybindings
            # colors = { }; # settings for coloring sway
	    defaultWorkspace = "workspace number 1";
	    # floating = { }; # settings for floating windows
	    # focus = { }; # settings for focus
	    fonts = {
	      names = [ "JetBrainsMono Nerd Font" ];
	      style = "Bold";
	      size = 10.0;
	    };
	    # gaps = { }; # settings for gaps
	    input = {
	      "1:1:AT_Translated_Set_2_keyboard" = {
		xkb_layout = "gb";
		xkb_model = "pc105";
	        xkb_options = "caps:escape_shifted_capslock";
	      };
	      "1267:29:Elan_Touchpad" = {
	        accel_profile = "flat";
		dwt = "enabled";
		natural_scroll = "enabled";
		pointer_accel = "0.5";
		tap = "enabled";
	      };
	    };
	    modifier = "Mod4";
	    keybindings = lib.mkOptionDefault {
	      "Mod4+Return" = "exec alacritty";
	      "Mod4+Shift+q" = "kill";
	      "Mod4+d" = "exec wofi --show=drun -IG";
	      "Mod4+Shift+c" = "reload";
	      "Mod4+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
	      "Mod4+h" = "focus left";
	      "Mod4+j" = "focus down";
	      "Mod4+k" = "focus up";
	      "Mod4+l" = "focus right";
	      "Mod4+Left" = "focus left";
	      "Mod4+Down" = "focus down";
	      "Mod4+Up" = "focus up";
	      "Mod4+Right" = "focus right";
	      "Mod4+Shift+h" = "move left";
	      "Mod4+Shift+j" = "move down";
	      "Mod4+Shift+k" = "move up";
	      "Mod4+Shift+l" = "move right";
	      "Mod4+Shift+Left" = "move left";
	      "Mod4+Shift+Down" = "move down";
	      "Mod4+Shift+Up" = "move up";
	      "Mod4+Shift+Right" = "move right";
	      "Mod4+1" = "workspace number 1";
	      "Mod4+2" = "workspace number 2";
	      "Mod4+3" = "workspace number 3";
	      "Mod4+4" = "workspace number 4";
	      "Mod4+5" = "workspace number 5";
	      "Mod4+6" = "workspace number 6";
	      "Mod4+7" = "workspace number 7";
	      "Mod4+8" = "workspace number 8";
	      "Mod4+9" = "workspace number 9";
	      "Mod4+0" = "workspace number 10";
	      "Mod4+Shift+1" = "move container to workspace number 1";
	      "Mod4+Shift+2" = "move container to workspace number 2";
	      "Mod4+Shift+3" = "move container to workspace number 3";
	      "Mod4+Shift+4" = "move container to workspace number 4";
	      "Mod4+Shift+5" = "move container to workspace number 5";
	      "Mod4+Shift+6" = "move container to workspace number 6";
	      "Mod4+Shift+7" = "move container to workspace number 7";
	      "Mod4+Shift+8" = "move container to workspace number 8";
	      "Mod4+Shift+9" = "move container to workspace number 9";
	      "Mod4+Shift+0" = "move container to workspace number 10";
	      "Mod4+b" = "splith";
	      "Mod4+v" = "splitv";
	      "Mod4+s" = "layout stacking";
	      "Mod4+w" = "layout tabbed";
	      "Mod4+e" = "layout toggle split";
	      "Mod4+f" = "fullscreen";
	      "Mod4+Shift+space" = "floating toggle";
	      "Mod4+space" = "focus mode_toggle";
	      "Mod4+a" = "focus parent";
	      "Mod4+Shift+minus" = "move scratchpad";
	      "Mod4+minus" = "scratchpad show";
	      "Mod4+r" = "mode resize";


	      # "Print" = "";
	      "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
	      "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
	      "XF86AudioMute" = "exec pulsemixer --toggle-mute";
	      "XF86AudioRaiseVolume" = "exec pulsemixer --change-volume +5";
	      "XF86AudioLowerVolume" = "exec pulsemixer --change-volume -5";
	      "XF86AudioMicMute" = "exec amixer set Capture toggle";
	      # "XF86AudioPlay" = "exec mpc toggle";
	      # "XF86AudioStop" = "exec mpc stop";
	      # "XF86AudioNext" = "exec mpc next";
	      # "XF86AudioPrev" = "exec mpc prev";
	    };
	    menu = "wofi --show=drun -IG";
	    modes = {
	      resize = {
                "h" = "resize shrink width 10px";
                "j" = "resize grow height 10px";
                "k" = "resize shrink height 10px";
                "l" = "resize grow width 10px";
                "Left" = "resize shrink width 10px";
                "Down" = "resize grow height 10px";
                "Up" = "resize shrink height 10px";
                "Right" = "resize grow width 10px";
                "Return" = "mode default";
                "Escape" = "mode default";
	      };
            };
	    output = {
	      eDP-1 = {
	        resolution = "1920x1080";
		position = "1920,0";
		bg = "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
	      };
	    };
	    # seat = { }; # define seat modules - sway-input(5)
	    # startup = [ ]; # startup commands { command = ""; always = bool; }
	    terminal = "alacritty";
	    window = { 
	      border = 1;
	      # commands = [ command = ""; criteria = { } ];
	      # hideEdgeBorders = "none"; # "none" "vertical" "horizontal" "both" "smart"
	      titlebar = false;
	    };
	    workspaceAutoBackAndForth = true; # press current workspace bind again to go back to last workspace
	    workspaceLayout = "default";
	    # workspaceOutAssign = [ { output = "eDP"; workspace = "Web" }; ];
	  };
	  # extraConfig = "";
	  # extraOptions = ""; # CLI arguments pass when sway launches
	  # extraSessionCommands = ""; Shell commands exectuted before Sway
	  swaynag = {
	    enable = true;
	  #   settings = { }; # swaynag(5)
	  };
	  systemdIntegration = true;
	  wrapperFeatures = {
	    # base = true;
	    gtk = true;
	  };
          xwayland = false;
	};
      };
    };
  };
}
