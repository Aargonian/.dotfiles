{ lib, config, ... }: with lib;
{
  imports = [
    ./anyrun
    ./waybar

    ./liferea.nix
    ./transmission.nix
  ];

  options.custom.programs.other.all = mkEnableOption "All 'other' Kinds of programs";

  config = mkIf config.custom.programs.other.all {
    custom.programs = {
      transmission.enable = true;
      liferea.enable = true;
    };
  };
}
