{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.laptop;
in
{
  options.richard.laptop = {
    enable = mkOption {
      description = "Whether to enable laptop settings. Also tags laptop for user settings";
      type = types.bool;
      default = false;
    };

    fprint = {
      enable = mkOption {
        description = "Enable fingerprint";
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    ({
      environment.systemPackages = with pkgs; [
        acpid
        powertop
        brightnessctl
      ];

      powerManagement = {
        cpuFreqGovernor = "powersave";
      };

      # systemd = {
      #   sleep.extraConfig =
      #     ''
      #       HiberanteDelaySec=30min
      #       SuspendMode=suspend
      #       SuspendState=disk
      #     '';
      # };

      services = {
        # udev.extraRules =
        #   ''
        #     # Suspend the system when battery level drops to 5% or lower
        #     SUBSYSTEM=="power_supply", ATTR(status)=="Discharging", ATTR(capacity)=="[0-5]", RIN+="${pkgs.systemd}/bin/systemctl hibernate"
        #   '';

        # logind = {
        #   extraConfig =
        #     ''
        #       HandleLidSwitch=suspend-then-hibernate
        #       HandlePowerKey=suspend-then-hiberate
        #       HandleSuspendKey=ignore
        #       HandleHibernateKey=ignore
        #       HandleSwitchDocked=ignore
        #       IdleAction=suspend-then-hibernate
        #       IdleActionSec=5min
        #     '';
        # };

        tlp = {
          enable = true;
          settings = {
            "SOUND_POWER_SAVE_ON_AC" = 1;
            "SOUND_POWER_SAVE_ON_BAT" = 1;
            "SOUND_POWER_SAVE_CONTROLLER" = "Y";
            "START_CHARGE_THRESH_BAT0" = 45;
            "STOP_CHARGE_THRESH_BAT0" = 75;
            "START_CHARGE_THRESH_BAT1" = 45;
            "STOP_CHARGE_THRESH_BAT1" = 75;
            "DISK_APM_LEVEL_ON_AC" = "254 254";
            "DISK_APM_LEVEL_ON_BAT" = "128 128";
            "DISK_IOSCHED" = "mq-deadline mq-deadline";
            "SATA_LINKPWR_ON_AC" = "med_power_with_dipm min_performance";
            "SATA_LINKPWR_ON_BAT" = "min_power min_power";
            "MAX_LOST_WORK_SECS_ON_AC" = 15;
            "MAX_LOST_WORK_SECS_ON_BAT" = 60;
            "NMI_WATCHDOG" = 0;
            "WIFI_PWR_ON_AC" = "off";
            "WIFI_PWR_ON_BAT" = "on";
            "WOL_DISABLE" = "Y";
            "CPU_SCALING_GOVERNOR_ON_AC" = "powersave";
            "CPU_SCALING_GOVERNOR_ON_BAT" = "powersave";
            "CPU_MIN_PERF_ON_AC" = 0;
            "CPU_MAX_PERF_ON_AC" = 50;
            "CPU_MIN_PERF_ON_BAT" = 0;
            "CPU_MAX_PERF_ON_BAT" = 50;
            "CPU_BOOST_ON_AC" = 1;
            "CPU_BOOST_ON_BAT" = 1;
            "SCHED_POWERSAVE_ON_AC" = 0;
            "SCHED_POWERSAVE_ON_BAT" = 1;
            "CPU_ENERGY_PERF_POLICY_ON_AC" = "power";
            "CPU_ENERGY_PERF_POLICY_ON_BAT" = "power";
            "RESTORE_DEVICE_STATE_ON_STARTUP" = 0;
            "RUNTIME_PM_ON_AC" = "auto";
            "RUNTIME_PM_ON_BAT" = "auto";
            "PCIE_ASPM_ON_AC" = "default";
            "PCIE_ASPM_ON_BAT" = "powersupersave";
            "USB_AUTOSUSPEND" = 0;
          };
        };
      };
    })
    (mkIf cfg.fprint.enable {
      services.fprintd.enable = true;
    })
  ]);
}
