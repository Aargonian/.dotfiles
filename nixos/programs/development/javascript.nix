{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.development.javascript.all = mkEnableOption "JavaScript Development Utilities";

  config = mkIf config.custom.programs.development.javascript.all {
    environment.systemPackages = with pkgs; [
      jq          # JSON Utility
      nodejs_22   # NodeJS Support
    ];
  };
}
