{ pkgs, home-manager, lib, system, overlays, ... }:
with builtins;
{
  mkHMUser = { userConfig, username }:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        let
          trySettings = tryEval (fromJSON (readFile /etc/hmsystemdata.json));
          machineData = if trySettings.success then trySettings.value else { };
          machineModule = { pkgs, config, lib, ... }: {
            options.machineData = lib.mkOption {
              default = { };
              description = "Settings passed from nixos system configuration. If not present will be empty";
            };
            config.machineData = machineData;
          };
        in
        [
          {
            richard = userConfig;
            nixpkgs.overlays = overlays;
            nixpkgs.config.allowUnfree = true;
            systemd.user.startServices = true;
            home = {
              stateVersion = "21.11";
              username = username;
              homeDirectory = "/home/${username}";
            };
          }
          ../modules/users
          machineModule
        ];
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
