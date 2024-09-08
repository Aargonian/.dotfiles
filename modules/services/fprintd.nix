{ lib, config, ...}:
{
  options.custom.services.fingerprint = {
    enable = lib.mkEnableOption "Fingerprint authentication services";
  };

  config = lib.mkIf config.custom.services.fingerprint.enable {
    services.fprintd.enable = true;
  };
}
