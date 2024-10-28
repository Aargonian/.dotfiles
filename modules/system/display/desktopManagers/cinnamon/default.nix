{ lib, config, ... }: with lib;
{
  options.custom.system.display.desktopManagers.cinnamon = {
    enable = mkEnableOption "Cinnamon Desktop Manager";
  };

  config = mkIf config.custom.system.display.desktopManagers.cinnamon.enable {
    # Setup XORG and Desktop variables if not already set
    custom.system.display.xorg.enable = true;

    # Install Cinnamon
    services.xserver.desktopManager.cinnamon.enable = true;
  };
}
