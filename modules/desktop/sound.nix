{lib, config, pkgs, ...}:
{
  options.custom.sound = {
    enable = lib.mkEnableOption "Sound";
  };

  config = lib.mkIf config.custom.sound.enable {
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = false;

    environment.systemPackages = lib.mkIf config.custom.desktop.enable [
      pkgs.pavucontrol
      pkgs.pa_applet
    ];
  };
}
