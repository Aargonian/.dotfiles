{ lib, config, pkgs, ... }: with lib;
{
  imports = [
    ./discord.nix
    ./hexchat.nix
    ./thunderbird.nix
  ];

  options.custom.programs.messaging.all = mkEnableOption "All messaging applications";

  config = mkIf config.custom.programs.messaging.all {
    custom.system.display.enable = true;

    custom.programs = {
      thunderbird.enable = true;
    };
  };
}
