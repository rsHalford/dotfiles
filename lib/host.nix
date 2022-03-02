{ system, pkgs, home-manager, lib, user, ... }:
with builtins;
{
  mkHost =
    { name
    , NICs
    , initrdMods
    , kernelMods
    , kernelParams
    , kernelPackage
    , kernelPatches
    , systemConfig
    , cpuCores
    , users
    , stateVersion ? "21.11"
    , wifi ? [ ]
    , passthru ? { }
    , gpuTempSensor ? null
    , cpuTempSensor ? null
    }:

    let
      networkCfg = listToAttrs (map
        (n: {
          name = "${n}";
          value = { useDHCP = true; };
        })
        NICs);

      userCfg = {
        inherit name NICs systemConfig cpuCores gpuTempSensor cpuTempSensor;
      };

      sys_users = (map (u: user.mkSystemUser u) users);

    in
    lib.nixosSystem {
      inherit system;

      modules = [
        {
          imports = [ ../modules/system ] ++ sys_users;

          richard = systemConfig;

          environment.etc = {
            "hmsystemdata.json".text = toJSON userCfg;
          };

          networking = {
            hostName = "${name}";
            interfaces = networkCfg;
            networkmanager.enable = true;
            useDHCP = false;
            wireless.interfaces = wifi;
          };

          boot = {
            initrd.availableKernelModules = initrdMods;
            kernelModules = kernelMods;
            kernelPackages = kernelPackage;
            kernelParams = kernelParams;
            kernelPatches = kernelPatches;
          };

          nixpkgs.pkgs = pkgs;
          nix.settings.max-jobs = lib.mkDefault cpuCores;

          system.stateVersion = stateVersion;
        }
      ];
    };
}
