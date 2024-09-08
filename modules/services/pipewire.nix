{ lib, config, ... }:
{
  # Pipewire for Audio and Screensharing
  options.custom.audio = {
    pipewire = {
      enable = lib.mkEnableOption "Pipewire";
    };
  };

  config = lib.mkIf config.custom.audio.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber = {
        enable = true;
      };
    };

    # Recommended for Pipewire and Pulseaudio
    security.rtkit.enable = true;
  };
}
