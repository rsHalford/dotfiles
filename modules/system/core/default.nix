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
    console = {
      colors = [
        "15161e"
        "f7768e"
        "9ece6a"
        "e0af68"
        "7aa2f7"
        "bb9af7"
        "7dcfff"
        "a9b1d6"
        "414868"
        "f7768e"
        "9ece6a"
        "e0af68"
        "7aa2f7"
        "bb9af7"
        "7dcfff"
        "c0caf5"
        "ff9e64"
        "db4b4b"
      ];
      # font = "";
      keyMap = "uk";
      # packages = with pkgs; [ ];
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
      loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec sway
        fi
      '';
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
    hardware.cpu.intel.updateMicrocode = true;
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
    services.flatpak.enable = true;

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
