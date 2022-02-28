{ pkgs, home-manager, lib, system, ... }:
with builtins;
{
  mkHMUser = { userConfig, username }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username pkgs;
      stateVersion = "21.11";
      configuration =
        let
	  trySettings = tryEval (fromJSON (readFile /etc/hmsystemdata.json));
	  machineData = if trySettings.success then trySettings.value else { };

	  machineModule = { pkgs, config, lib, ... }: {
	    options.machineData = lib.mkOption {
	      default = {};
	      description = "Settings passed from nixos system configuration. If not present will be empty";
	    };

	    config.machineData = machineData;
	  };
	in
	{
	  richard = userConfig;

	  nixpkgs.config.allowUnfree = true;

	  systemd.user.startServices = true;
	  home = {
	    stateVersion = "21.11";
	    username = username;
	    homeDirectory = "/home/${username}";
	  };
	  imports = [ ../modules/users machineModule ]; # add pkgs.homeage.homeManagerModules.homeage
	};
      homeDirectory = "/home/${username}";
    };

  mkSystemUser = { description, groups, name, shell, uid, ... }:
    {
      # users.defaultUserShell = pkgs.zsh;
      users.users."${name}" = {
        description = description;
        extraGroups = groups;
        initialPassword = "helloworld";
        isNormalUser = true;
	isSystemUser = false;
        name = name;
        shell = shell;
        uid = uid;
      };
    };
}
