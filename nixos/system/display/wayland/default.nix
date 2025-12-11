{ lib, config, ... }: with lib;
{
  options.custom.system.display.wayland = {
    enable = mkEnableOption "Wayland Windowing System";

    errorIfXorgEnabled = mkEnableOption "Force an error if xorg/X11 is accidentally enabled.";
  };

  config = {
    # If xorg erroring is enabled, we attempt to force-disable xorg with errors if something turns it on
    services.xserver = mkIf config.custom.system.display.wayland.errorIfXorgEnabled {
      enable = false;
    };
  };
}
