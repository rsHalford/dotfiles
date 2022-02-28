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
      enable = true;
      dev.enable = true;
      doc.enable = true;
      man = {
        enable = true;
	generateCaches = true;
      };
      info.enable = true;
      nixos.enable = true;
    };

    environment = {
      binsh = "${pkgs.dash}/bin/dash";
      loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec sway
        fi
      '';
      pathsToLink = [ "/share/zsh" ];
      # shells = [ pkgs.zsh ];
      systemPackages = with pkgs; [
        dash
        git
        neovim
        zsh
      ];
    };

    # hardware.enableRedistributableFirmware = lib.mkDefault true;
    # hardware.enableAllFirmware = lib.mkDefault true;
    # hardware.cpu.${system architecture}.updateMicrocode = true;

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
        # keep-outputs = true;
	# keep-derivations = true;
        experimental-features = nix-command flakes
      '';
    };

    programs.sway.enable = true;
    # security.pam.services.swaylock = mkIf (cfg.swaylock-pam) { };

    # powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    # security.sudo.extraConfig = "Defaults env_reset,timestamp_timeout=5";
    # security.sudo.execWheelOnly = true;

    time.timeZone = "Europe/London";
  };
}
