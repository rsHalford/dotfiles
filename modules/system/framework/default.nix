{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.framework;
in {
  options.richard.framework = {
    enable = mkOption {
      description = "Whether to enable framework settings. Also tags framework for user settings";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    environment = {
      systemPackages = with pkgs; [
        acpid
        brightnessctl
        mangohud
        pamixer
      ];

      etc."sway/config.d/framework.conf".text = ''
        bindsym Mod4+w exec $BROWSER
        bindsym XF86AudioLowerVolume exec pamixer --decrease 5
        bindsym XF86AudioMicMute exec amixer set Capture toggle
        bindsym XF86AudioMute exec pamixer --toggle-mute
        bindsym XF86AudioRaiseVolume exec pamixer --increase 5
        bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
        bindsym XF86MonBrightnessUp exec brightnessctl set +5%
      '';
    };

    hardware = {
      cpu.amd.updateMicrocode = true;
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };

    programs = {
      gamemode = {
        enable = true;
        settings = {
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      steam = {
        enable = true;
        gamescopeSession = {
          enable = true;
          args = [
            "-W 2256 -H 1504"
            "-w 1440 -h 960"
            "-r 30"
            "-F fsr"
            "--adaptive-sync"
          ];
          env = {};
        };
        dedicatedServer.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };

    services = {
      fprintd.enable = true;
      fwupd.enable = true;
      power-profiles-daemon.enable = true;
      xserver = {
        libinput = {
          touchpad = {
            accelProfile = "flat";
            accelSpeed = "0.5";
            disableWhileTyping = true;
            naturalScrolling = true;
            tapping = true;
            tappingButtonMap = "lrm";
          };
        };
        xkb = {
          layout = "gb";
          model = "pc105";
          options = "caps:escape_shifted_capslock";
        };
      };
    };

    users.motd = ''

      Enter the session evironment you want to start...
      ''\tsway
      ''\tsteam-gamescope

    '';
  };
}
