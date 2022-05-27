{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.richard.terminal.emulator;
in
{
  imports = [
    ./alacritty.nix
    ./foot.nix
  ];

  options.richard.terminal.emulator = {
    program = mkOption {
      description = "Choose terminal emulator. Default is foot.";
      type = types.enum [ "alacritty" "footclient" "foot" ];
      default = "foot";
    };
  };
}
