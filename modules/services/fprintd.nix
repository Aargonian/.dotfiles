{ lib, config, ... }: with lib;
{
  options.custom.services.fingerprint = {
    enable = mkEnableOption "fingerprint authentication services";
  };

  config = mkIf config.custom.services.fingerprint.enable {
    services.fprintd.enable = true;
  } // mkIf (!config.custom.services.fingerprint.enable) {
    services.fprintd.enable = false;
  };
}
