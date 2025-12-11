{ lib, config, ... }: with lib;
{
  options.custom.programs.touchpad.enable = mkEnableOption "Touchpad drivers from libinput";

  config = mkIf config.custom.programs.touchpad.enable {
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
    services.libinput.touchpad.naturalScrolling = true;
  };
}
