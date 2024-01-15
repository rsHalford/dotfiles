{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.security;
in {
  imports = [~/.dotfiles/secrets/security];

  options.richard.security = {
    gpg.enable = mkOption {
      description = "Enable gpg";
      type = types.bool;
      default = false;
    };

    pass.enable = mkOption {
      description = "Enable password-store";
      type = types.bool;
      default = false;
    };

    ssh.enable = mkOption {
      description = "Enable client-side SSH";
      type = types.bool;
      default = false;
    };
  };

  config = {
    home.packages = with pkgs; [
      git-secret
      gnupg
      gopass
      pinentry-qt
    ];

    programs = {
      gpg = {
        enable = cfg.gpg.enable;
        homedir = "${config.xdg.dataHome}/gnupg";
        # publicKeys = [{
        #   source = null;
        #   text = "";
        #   trust = "ultimate";
        # }];
        # scdaemonSettings = { };
        # settings = { };
      };

      password-store = {
        enable = cfg.pass.enable;
        # package = with pkgs; [ (pass.withExtensions (exts: [ exts.pass-otp ])) ];
      };

      ssh = {
        enable = cfg.ssh.enable;
        # compression = false;
        # controlMaster = "no";
        # controlPath = "~/.ssh/master-%r@%n:%p";
        # controlPersist = "no";
        # extraConfig = "";
        # extraOptionOverrides = { };
        # forwardAgent = false;
        # hashKnownHosts = false;
        # includes = [ ];
        # serverAliveCountMax = 3;
        # serverAliveInterval = 0;
        # userKnownHostsFile = "~/.ssh/known_hosts";
      };
    };

    services = {
      gpg-agent = {
        enable = cfg.gpg.enable;
        enableScDaemon = true;
        enableSshSupport = true;
        pinentryFlavor = "qt";
      };
    };
  };
}
