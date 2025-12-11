{ lib, config, pkgs, ... }: with lib;
{
  imports = [
    ./xfce4-terminal.nix
    ./gnome-terminal.nix
  ];

  options.custom.programs.terminal.all = mkEnableOption "All Terminal Programs.";

  config = mkIf config.custom.programs.shell.all {
    custom.programs = {
      xfce4-terminal.enable = true;
      gnome-terminal.enable = true;
    };
  };
}
