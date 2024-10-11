{ lib, config, pkgs, ... }: with lib;
{
  # Pipewire for Audio and Screensharing
  options.custom.services.pipewire = {
    enable = mkEnableOption "Pipewire";
  };

  config = mkIf config.custom.services.pipewire.enable {
    # Recommended for Pipewire and Pulseaudio
    security.rtkit.enable = mkDefault true;

    services.pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;

      wireplumber = {
        enable = mkDefault true;
      };
    };

    # Pulseaudio needs to be disabled for pipewire
    hardware.pulseaudio.enable = false;
  };
}
