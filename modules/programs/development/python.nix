{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.development.python.all = mkEnableOption "Python development tools";

  config = mkIf config.custom.programs.development.python.all {
    environment.systemPackages = with pkgs; [
      python3
    ];
  };
}
