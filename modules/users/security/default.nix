{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.security;
in
{
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
        matchBlocks = {
          "hydrogen" = {
            hostname = "xhalford.com";
            user = "richard";
            port = 22;
            identitiesOnly = true;
            identityFile = "~/.ssh/id_rsa_yubikey.pub";
          };
          "github.com" = {
            hostname = "github.com";
            identitiesOnly = true;
            identityFile = "~/.ssh/id_rsa_yubikey.pub";
          };
          #   <name> = {
          #     addressFamily = null;
          #     certificateFile = [ ];
          #     checkHostIP = true;
          #     compression = null;
          #     dynamicForwards = [
          #       address = "localhost";
          #       port = null;
          #     ];
          #     extraOptions = { };
          #     forwardAgent = null;
          #     forwardX11 = false;
          #     forwardX11Trusted = false;
          #     host = "";
          #     hostname = null;
          #     identitiesOnly = false;
          #     identityFile = "";
          #     localForwards = [ ];
          #     port = null;
          #     proxyCommand = null;
          #     proxyJump = null;
          #     remoteForwards = [ ];
          #     sendEnv = [ ];
          #     serverAliveCountMax = 3;
          #     serverAliveInterval = 0;
          #     user = "";
          #   };
        };
        # serverAliveCountMax = 3;
        # serverAliveInterval = 0;
        # userKnownHostsFile = "~/.ssh/known_hosts";
      };
    };

    services = {
      gpg-agent = {
        enable = cfg.gpg.enable;
        # enableExtraSocket = false;
        enableScDaemon = true;
        enableSshSupport = true;
        # defaultCacheTtl = null;
        # defaultCacheTtlSsh = null;
        # extraConfig = "";
        # maxCacheTtl = null;
        # maxCacheTtlSsh = null;
        pinentryFlavor = "qt";
        # sshKeys = null;
        # verbose = false;
      };
    };
  };
}
