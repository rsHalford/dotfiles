{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    # emacs-unstable = {
    #   url = "github:nix-community/emacs-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    godo-flake = {
      url = "github:rsHalford/godo";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tag-flake = {
      url = "github:rsHalford/tag";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    nur,
    # emacs-unstable,
    godo-flake,
    tag-flake,
    ...
  }: let
    inherit (nixpkgs) lib;

    util = import ./lib {
      inherit system pkgs home-manager lib overlays;
    };

    scripts = import ./scripts {
      inherit pkgs lib;
    };

    inherit
      (import ./overlays {
        inherit
          system
          pkgs
          lib
          nixvim
          nur
          # emacs-unstable
          
          godo-flake
          tag-flake
          scripts
          ;
      })
      overlays
      ;

    inherit (util) user;
    inherit (util) host;

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    system = "x86_64-linux";

    defaultConfig = {
      boot = "systemd-boot";
      connectivity = {
        bluetooth.enable = true;
        kde-connect.enable = true;
        printing.enable = true;
        sound.enable = true;
        virtualisation.enable = true;
        vpn.enable = true;
      };
      core.enable = true;
    };

    desktopConfig =
      defaultConfig
      // {
        desktop.enable = true;
      };

    laptopConfig =
      defaultConfig
      // {
        laptop = {
          enable = true;
          fprint = {
            # enable = true;
          };
        };
      };

    frameworkConfig =
      defaultConfig
      // {
        framework = {
          enable = true;
        };
      };

    defaultUser = [
      {
        name = "richard";
        description = "Richard Halford";
        groups = [
          "audio"
          "libvirtd"
          "input"
          "networkmanager"
          "storage"
          "video"
          "wheel"
        ];
        uid = 1000;
        shell = pkgs.zsh;
      }
    ];
  in {
    homeManagerConfigurations = {
      richard = user.mkHMUser {
        userConfig = {
          browser = {
            http = {
              brave.enable = true;
              firefox.enable = false;
              qutebrowser.enable = false;
              preferred = "brave";
            };
            gemini = {
              amfora.enable = false;
            };
          };
          core.enable = true;
          development = {
            emacs.enable = false;
            helix.enable = false;
            languages = {
              go.enable = true;
            };
            neovim.enable = true;
          };
          fonts = {
            monospace = {
              name = "BlexMono"; # IBM Plex
              pkg = "IBMPlexMono";
            };
            sans = "Lexend";
            serif = "Gelasio"; # Georgia
          };
          direnv.enable = true;
          gaming.enable = true;
          git = {
            enable = true;
            userName = "Richard Halford";
            userEmail = "dev@rshalford.com";
            signByDefault = true;
          };
          graphical = {
            compositor = {
              hyprland.enable = true;
              river.enable = true;
              sway.enable = true;
            };
            menu.enable = true;
            utilities = {
              enable = true;
              editor = "emacsclient -c";
            };
            virtualisation.enable = true;
          };
          media = {
            enable = true;
            newsboat.enable = true;
          };
          messaging.enable = false;
          security = {
            gpg.enable = true;
            pass.enable = true;
            ssh.enable = true;
          };
          services = {
            blueman.enable = true;
            gammastep.enable = true;
            kanshi.enable = true;
            kde-connect.enable = true;
            mako.enable = true;
            mpd.enable = true;
            mpris.enable = true;
            newsboat.enable = false;
            protonmail-bridge.enable = false;
            syncthing.enable = true;
            udiskie.enable = true;
          };
          suite = {
            mail = {
              enable = false;
              client = "thunderbird";
            };
            office.enable = true;
            tex.enable = false;
          };
          terminal = {
            emulator.program = "foot";
            shell.enable = true;
            utilities = {
              enable = true;
              editor = "nvim";
            };
          };
          theme = {
            # TODO: `cursor` attribute set for package, name and size
            # cursor = {};
            # TODO: `colors` attribute set for packages, name, and values
            # colors = {};
            name = "tokyonight";
            gtk = pkgs.tokyo-night-gtk;
            foreground = "c0caf5";
            background = "1a1b26";
            regular0 = "15161e"; # black
            regular1 = "f7768e"; # red
            regular2 = "9ece6a"; # green
            regular3 = "e0af68"; # yellow
            regular4 = "7aa2f7"; # blue
            regular5 = "bb9af7"; # magenta
            regular6 = "7dcfff"; # cyan
            regular7 = "a9b1d6"; # white
            bright0 = "414868"; # black
            bright1 = "f7768e"; # red
            bright2 = "9ece6a"; # green
            bright3 = "e0af68"; # yellow
            bright4 = "7aa2f7"; # blue
            bright5 = "bb9af7"; # magenta
            bright6 = "7dcfff"; # cyan
            bright7 = "c0caf5"; # white
            color16 = "ff9e64";
            color17 = "db4b4b";
          };
        };
        username = "richard";
      };
    };

    nixosConfigurations = {
      desktop = host.mkHost {
        name = "desktop";
        NICs = ["wlp14s0" "enp13s0"];
        initrdMods = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
        kernelMods = ["kvm-intel"];
        kernelPackage = pkgs.linuxPackages_latest;
        kernelParams = [];
        kernelPatches = [];
        systemConfig = desktopConfig;
        users = defaultUser;
        cpuCores = 4;
        stateVersion = "23.05";
      };
      external = host.mkHost {
        name = "external";
        NICs = ["wlp2s0" "enp0s31f6"];
        initrdMods = ["xhci_pci" "nvme" "uas" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
        kernelMods = ["kvm-intel"];
        kernelPackage = pkgs.linuxPackages_latest;
        kernelParams = [];
        kernelPatches = [];
        systemConfig = laptopConfig;
        users = defaultUser;
        cpuCores = 4;
        stateVersion = "21.11";
      };
      laptop = host.mkHost {
        name = "laptop";
        NICs = ["wlp2s0" "enp0s31f6"];
        initrdMods = ["xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
        kernelMods = ["kvm-intel"];
        kernelPackage = pkgs.linuxPackages_latest;
        kernelParams = [];
        kernelPatches = [];
        systemConfig = laptopConfig;
        users = defaultUser;
        cpuCores = 4;
        stateVersion = "21.11";
      };
      framework = host.mkHost {
        name = "framework";
        NICs = ["wlp1s0"];
        initrdMods = ["xhci_pci" "nvme" "thunderbolt" "usb_storage" "sd_mod"];
        kernelMods = ["kvm-amd"];
        kernelPackage = pkgs.linuxPackages_latest;
        kernelParams = [];
        kernelPatches = [];
        systemConfig = frameworkConfig;
        users = defaultUser;
        cpuCores = 8;
        stateVersion = "23.05";
      };
    };
  };
}
