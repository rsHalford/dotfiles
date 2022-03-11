{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.git;
in
{
  options.richard.git = {
    enable = mkOption {
      description = "Enable git";
      type = types.bool;
      default = false;
    };

    userName = mkOption {
      description = "Name for git";
      type = types.str;
      default = "Richard Halford";
    };

    userEmail = mkOption {
      description = "Email for git";
      type = types.str;
      default = "richard@xhalford.com";
    };

    signByDefault = mkOption {
      description = "GPG signing key for git";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      git
    ];
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      # aliases = { };
      # attributes = [ ];
      # delta = {
      #   enable = false;
      #   options = { };
      # };
      extraConfig = {
        commit.gpgSign = cfg.signByDefault;
	# gpg = {
	#   format = "ssh";
	#   ssh = {
	#     defaultKeyCommand = "${pkgs.openssh}/bin/ssh-add -L";
	#     program = "${pkgs.openssh}/bin/ssh-keygen";
	#     allowedSignersFile =
	#       let
	#         file = pkgs.writeTextFile {
	# 	name = "git-authorized-keys";
	#         text = ''
	# 	  richard@xhalford.com ssh-...
	#         '';
	# 	};
	#       in
	#       builtins.toString file;
	#   };
	# };
	# credential.helper = "${
	#     pkgs.git.override { withLibSecret = true; }
	#   }/bin/git-credential-libsecret";
	init.defaultBranch = "main";
	# pull.rebase = "true";
      };
      # ignores = [ ];
      # includes = [ ];
      # signing = {
      #   gpgPath = "\${pkgs.gnupg}/bin/gpg2";
      #   key = null;
      #   signByDefault = false;
      # };
    };
  };
}
