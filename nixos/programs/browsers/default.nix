{ lib, config, ... }: with lib;
{
  imports = [
    ./firefox.nix
  ];

  options.custom.programs.browsers.all = mkEnableOption "All web browsers";

  config = mkIf config.custom.programs.browsers.all {
    custom.programs.firefox.enable = true;
  };
}
