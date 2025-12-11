{ lib, config, ... }: with lib;
{
  options.custom.services.power-profiles-daemon.enable = mkEnableOption "Power Profile Daemon";

  config = mkIf config.custom.services.power-profiles-daemon.enable {
    services.power-profiles-daemon.enable = true;
  };
}
