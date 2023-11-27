{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.core;
  regular0 = "15161e"; # black
  regular1 = "f7768e"; # red
  regular2 = "9ece6a"; # green
  regular3 = "e0af68"; # yellow
  regular4 = "7aa2f7"; # blue
  regular5 = "bb9af7"; # magenta
  regular6 = "7dcfff"; # cyan
  regular7 = "a9b1d6"; # white
  bright0 = "414868"; # black
  bright1 = "f7768e"; # red
  bright2 = "9ece6a"; # green
  bright3 = "e0af68"; # yellow
  bright4 = "7aa2f7"; # blue
  bright5 = "bb9af7"; # magenta
  bright6 = "7dcfff"; # cyan
  bright7 = "c0caf5"; # white
  greetdConfig = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
  '';
in {
  options.richard.core = {
    enable = mkOption {
      description = "Enable core options";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    console = {
      colors = [
        regular0
        regular1
        regular2
        regular3
        regular4
        regular5
        regular6
        regular7
        bright0
        bright1
        bright2
        bright3
        bright4
        bright5
        bright6
        bright7
      ];
      keyMap = "uk";
    };

    documentation = {
      dev.enable = true;
      man = {
        man-db.enable = false;
        mandoc.enable = true;
      };
      nixos.enable = true;
    };

    environment = {
      pathsToLink = ["/share/zsh"];
      shells = [pkgs.zsh];
      systemPackages = with pkgs; [
        cachix
        cryptsetup
        git
        jq
        libnotify
        neovim
        ripgrep
        scripts.sysTools
        tldr
        zsh
      ];
    };

    hardware.enableRedistributableFirmware = true;
    hardware.keyboard.qmk.enable = true;

    i18n.defaultLocale = "en_GB.UTF-8";

    nix = {
      package = pkgs.nixUnstable;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
        persistent = true;
      };
      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
        experimental-features = nix-command flakes
      '';
      settings = {
        substituters = ["https://nix-community.cachix.org"];
        trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
        trusted-users = ["@wheel"];
      };
    };

    programs.dconf.enable = true;
    programs.sway.enable = true;
    programs.zsh.enable = true;
    # security.pam.services.swaylock = mkIf (cfg.swaylock-pam) { };

    # security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=5";
    # security.sudo.execWheelOnly = true;

    services = {
      flatpak.enable = true;
      greetd = {
        enable = true;
        package = pkgs.greetd.gtkgreet;
        settings = {
          default_session = {
            command = "${pkgs.sway}/bin/sway --config ${greetdConfig}";
            user = "greeter";
          };
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      sway
      steam-gamescope
      zsh
    '';

    time.timeZone = "Europe/London";

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
        wlr = {
          enable = true;
          # settings = { }; # man xdg-desktop-portal-wlr
        };
      };
    };
  };
}
