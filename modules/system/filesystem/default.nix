{ lib, config, pkgs, ... }: with lib;
{

  options.custom.system.filesystem.gvfs = {
    enable = mkEnableOption "GVFS";
  };

  config = {
    # GVFS for Samba Share
    services.gvfs = mkIf config.custom.system.filesystem.gvfs.enable {
      enable = true;
      package = pkgs.gnome3.gvfs;
    };

    custom.services.polkit.enable = config.custom.system.filesystem.gvfs.enable;
  };
}
