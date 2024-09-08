{lib, pkgs, config, ...}:
{
  options.custom = {
    displaylink.enable = lib.mkEnableOption "Displaylink drivers";
  };

  config = lib.mkIf config.custom.displaylink.enable {
    # DisplayLink Driver Support
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
    services.xserver.displayManager.sessionCommands = ''
        ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
    '';

    # Note: The following command may need to be ran before the DL driver will work:
    # nix-prefetch-url --name displaylink-580.zip https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip
  };
}
