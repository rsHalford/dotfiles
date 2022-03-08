{ pkgs, config, lib, ...}:
with lib;

let
  cfg = config.richard.graphical.utilities;
in
{
  options.richard.graphical.utilities = {
    enable = mkOption {
      description = "Enable graphical utilities";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      gammastep
      kanshi
      mako
      waybar
      wofi
      wl-clipboard
    ];
    programs = {
      mako = {
        enable = true;
        actions = true;
        anchor = "top-right";
        backgroundColor = "#282828";
        borderColor = "#458588";
        borderRadius = 0;
        borderSize = 3;
        defaultTimeout = 10000;
        extraConfig = "";
        font = "JetBrainsMono Nerd Font";
        format = ''<b>%s</b>\n%b'';
        groupBy = null;
        height = 100;
        iconPath = null;
        icons = true;
        ignoreTimeout = false;
        layer = "overlay";
        margin = "10,10,5";
        markup = true;
        maxIconSize = 32;
        maxVisible = 5;
        output = null;
        padding = "0,10,20";
        progressColor = "over #665c54";
        sort = "-time";
        textColor = "#fbf1c7";
        width = 300;
      };
      waybar = {
        enable = true;
        # settings = [ ];
        # style = "";
        systemd.enable = true;
      };
    };
    gtk = {
      enable = true;
      font = {
	# package = with pkgs; (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
	name = "JetBrainsMono Nerd Font";
	size = 10;
      };
      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
	extraConfig = "";
      };
      gtk3 = {
        extraConfig = { };
	extraCss = "";
      };
      gtk4 = {
        extraConfig = { };
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
	name = "Papirus Dark";
      };
      theme = {
        package = pkgs.gnome.gnome-themes-extra;
	name = "Adwaita";
      };
    };
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = {
        package = pkgs.adwaita-qt;
        name = "adwaita-dark";
      };
    };
    services = {
      gammastep = {
        enable = true;
	dawnTime = "06:30-08:30";
	duskTime = "20:30-22:00";
	settings = {
	  general = {
	    fade = 1;
	    brightness-day = 1.0;
	    brightness-night = 0.4;
	    adjustment-method = "wayland";
	  };
	};
	temperature = {
	  day = 6500;
	  night = 2800;
	};
	tray = false;
      };
      kanshi = {
        enable = true;
	profiles = {
	  undocked = {
	    outputs = [{
	      criteria = "eDP-1";
	      position = "0,0";
	      status = "enable";
	    }];
	  };
	  docked = {
	    outputs = [
	      {
	        criteria = "eDP-1";
	        status = "disable";
	      }
	      {
	        criteria = "Dell Inc. DELL U2515H 9X2VY5CA0QTL";
	        position = "0,0";
	        scale = 1.0;
	        status = "enable";
	      }
	    ];
	  };
	};
      };
    };
  };
}
