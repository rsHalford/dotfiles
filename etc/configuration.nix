# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Shutdown" {
            halt
          }
        '';
        useOSProber = true;
        version = 2;
      };
      timeout = 3;
    };
    plymouth = {
      enable = true;
    };
  };

  console = {
    keyMap = "uk";
  };

  documentation = {
    dev.enable = true;
    man = {
      enable = true;
      generateCaches = true;
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
      brightnessctl
      cachix
      git
      jq
      libnotify
      neovim
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
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.sway.enable = true;

  time.timeZone = "Europe/London";

  networking = {
    hostName = "laptop";
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp2s0.useDHCP = true;
    };
    networkmanager.enable = true;
    useDHCP = false;
  };

  users.users.richard = {
    name = "richard";
    description = "Richard Halford";
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "storage"
      "video"
      "wheel"
    ];
    initialPassword = "helloworld";
    isNormalUser = true;
    isSystemUser = false;
    shell = pkgs.zsh;
    uid = 1000;
  };

  system.stateVersion = "21.11";
}
