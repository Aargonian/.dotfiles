{ lib, config, pkgs, ... }: with lib;
{
  options.custom.system.displaylink.enable = mkEnableOption "Displaylink drivers";

  config = mkIf config.custom.system.displaylink.enable {
    custom.system.display.enable = true;

    # DisplayLink Driver Support
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
    services.xserver.displayManager.sessionCommands = ''
        ${getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
    '';

    # Note: The following command may need to be ran before the DL driver will work:
    # nix-prefetch-url --name displaylink-580.zip https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip
  };
}
