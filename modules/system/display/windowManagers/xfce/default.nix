{ lib, config, pkgs, ... }: with lib;
{
  options.custom.system.display.windowManagers.xfce4 = {
    enable = mkEnableOption "XFCE4 Desktop Manager";
  };

  config = mkIf config.custom.system.display.windowManagers.xfce4.enable {
    custom = {
      # Xorg is required for XFCE4
      system.display.xorg.enable = true;

      # Enable various programs by default
      programs = {
        thunar.enable = true;
      };
    };

    # Various other useful packages
    environment.systemPackages = with pkgs.xfce; mkDefault [
      xfce4-terminal # Terminal
    ];

    # Install XFCE4
    services.xserver.desktopManager.xfce.enable = true;
  };
}
