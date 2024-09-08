{ lib, config, ...}:
{
  options.custom.touchpad = {
    enable = lib.mkEnableOption "Touchpad drivers from libinput";
  };

  config = lib.mkIf config.custom.touchpad.enable {
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
    services.libinput.touchpad.naturalScrolling = true;
  };
}
