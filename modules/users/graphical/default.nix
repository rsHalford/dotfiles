{ pkgs, config, lib, ...}:
with lib;

let
  cfg = config.richard.graphical;
in
{
  options.richard.graphical = {
    enable = mkOption {
      description = "Enable graphical";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      waybar
    ];
    programs = {
      waybar = {
        enable = true;
        # settings = [ ];
        # style = "";
        systemd.enable = true;
      };
    };
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
	    # defaultWorkspace = null;
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
	    };
	    # keybindings = { }; # use separate lib.mkOptionDefault in file
	    # menu = "\${pkgs.dmenu}/bin/dmenu_path | \${pkgs.dmenu}/bin/dmenu | \${pkgs.findutils}/bin/xargs swaymsg exec --";
	    # modes = { }; # basic bindsym keycomb action mode bindings (use extraConfig)
	    modifier = "Mod4";
	    output = {
	      Virtual-1 = { resolution = "1920x1080"; position = "1920,0"; bg = "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill"; };
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
          # xwayland = true;
	};
      };
    };
  };
}
