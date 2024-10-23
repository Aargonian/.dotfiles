{ lib, config, pkgs, ... }: with lib;
{
  options.custom.system.display.windowManagers.startx = {
    enable = mkEnableOption "Startx/Xinit Support for starting xorg from cli";
  };

  config = mkIf config.custom.system.display.windowManagers.startx.enable {
    custom.system.display.xorg.enable = true;

    services.xserver.displayManager.startx.enable = true;

    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        xorg.xinit
      ];
      # Unfortunately, there is (to my knowledge) not a way to configure xinitrc through nix, so we'll write it manually
      home.file."Data/Configuration/RC/xinitrc".text = ''
        #!/usr/bin/env sh

        # start cinnamon
        export `dbus-launch`
        exec cinnamon-session
      '';
    };
  };
}
