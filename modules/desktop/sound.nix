{lib, config, ...}:
{
  options.custom.sound = {
    enable = lib.mkEnableOption "Sound";
  };

  config = lib.mkIf config.custom.sound.enable {
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
  };
}
