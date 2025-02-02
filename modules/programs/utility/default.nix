{ lib, config, ...}: with lib;
{
  imports = [
    ./applets.nix
    ./common.nix
    ./fcitx.nix
    ./printing.nix
    ./thunar.nix
    ./tigervnc.nix
    ./tmux.nix
    ./touchpad.nix
    ./via.nix
  ];

  options.custom.programs.utility.all = mkEnableOption "Common uiltitiy programs";

  config = mkIf config.custom.programs.utility.all {
    custom.programs = {
      utility = {
        applets.all = true;
        common.all = true;
      };

      fcitx.enable = true;
      printing.enable = true;
      thunar.enable = true;
      tigervnc.enable = true;
      tmux.enable = true;
      touchpad.enable = true;
      via.enable = true;
    };
  };
}
