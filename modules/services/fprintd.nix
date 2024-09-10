{ lib, config, ...}:
{
  options.custom.services.fingerprint = {
    enable = lib.mkEnableOption "fingerprint authentication services";
  };

  config = lib.mkIf config.custom.services.fingerprint.enable {
    services.fprintd.enable = true;
  } // lib.mkIf (!config.custom.services.fingerprint.enable) {
    services.fprintd.enable = false;
  };
}
