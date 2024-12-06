{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.development.common.all = mkEnableOption "Common development tools";

  config = mkIf config.custom.programs.development.common.all {
    environment.systemPackages = with pkgs; [
      git
      cmakeMinimal
      gcc
      gnumake
      automake

      sqlite
      jq
    ];
  };
}
