{ lib, config, pkgs, ... }: with lib;
{
  imports = [
    ./calibre.nix
    ./libreoffice.nix
    ./obsidian.nix
    ./todoist.nix
  ];

  options.custom.programs.productivity.all = mkEnableOption "All productivity applications";

  config = mkIf config.custom.programs.productivity.all {
    custom.system.display.enable = true;

    custom.programs = {
      calibre.enable = true;
      libreoffice.enable = true;
      obsidian.enable = true;
      todoist.enable = true;
    };
  };
}
