{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.core;
in {
  options.richard.core = {
    enable = mkOption {
      description = "Enable core options";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    console.useXkbConfig = true;

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

    programs = {
      dconf.enable = true;
      sway.enable = true;
      zsh.enable = true;
    };

    # security.pam.services.swaylock = mkIf (cfg.swaylock-pam) { };

    # security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=5";
    # security.sudo.execWheelOnly = true;

    services = {
      flatpak.enable = true;
      xserver.xkb = {
        layout = "gb";
      };
    };

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
