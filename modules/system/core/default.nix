{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.core;
in
{
  options.richard.core = {
    enable = mkOption {
      description = "Enable core options";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    console = {
      # colors = [ ];
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
      loginShellInit =
        ''
          if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec sway
          fi
        '';
      pathsToLink = [ "/share/zsh" ];
      shells = [ pkgs.zsh ];
      systemPackages = with pkgs; [
        cachix
        git
        jq
        libnotify
        neovim
        mullvad-vpn
        scripts.sysTools
        tldr
        zsh
      ];
    };

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = true;

    i18n.defaultLocale = "en_GB.UTF-8";

    nix = {
      package = pkgs.nixUnstable;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
        persistent = true;
      };
      extraOptions =
        ''
          keep-outputs = true;
          keep-derivations = true;
          experimental-features = nix-command flakes
        '';
      settings = {
        substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      };
    };

    programs.sway.enable = true;
    # security.pam.services.swaylock = mkIf (cfg.swaylock-pam) { };

    # security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=5";
    # security.sudo.execWheelOnly = true;
    services.flatpak.enable = true;

    time.timeZone = "Europe/London";

    xdg = {
      portal = {
        enable = true;
        wlr = {
          enable = true;
          # settings = { };
        };
      };
    };
  };
}
