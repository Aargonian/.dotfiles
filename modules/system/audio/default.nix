{ lib, config, pkgs, ... }: with lib;
{
  options.custom.system.audio = {
    enable = mkEnableOption "Sound";
  };

  config = mkIf config.custom.system.audio.enable {
    # Enable sound.
    sound.enable = true;

    # Use pipewire by default
    custom.services.pipewire.enable = mkDefault true;
  };
}
