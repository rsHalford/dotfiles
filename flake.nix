{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    emacs-unstable = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    nur,
    emacs-unstable,
    godo-flake,
    tag-flake,
    ...
  } @ inputs: let
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
          nur
          emacs-unstable
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
      boot = "encrypted-efi";
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
              firefox.enable = true;
              qutebrowser.enable = true;
              preferred = "firefox";
            };
            gemini = {
              amfora.enable = true;
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
          direnv.enable = true;
          gaming.enable = true;
          git = {
            enable = true;
            userName = "Richard Halford";
            userEmail = "richard@xhalford.com";
            signByDefault = true;
          };
          graphical = {
            compositor.enable = true;
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
          messaging.enable = true;
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
            mpd.enable = true;
            mpris.enable = true;
            newsboat.enable = true;
            syncthing.enable = true;
          };
          suite = {
            mail.enable = false;
            office.enable = true;
            tex.enable = true;
          };
          terminal = {
            emulator.program = "foot";
            shell.enable = true;
            utilities = {
              enable = true;
              editor = "nvim";
            };
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
        stateVersion = "21.11";
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
    };
  };
}
