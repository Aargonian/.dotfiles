{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.thunar = {
    enable = mkEnableOption "Thunar File Manager";
  };

  config = mkIf config.custom.programs.thunar.enable {
    custom.system.display.enable = true;

    programs.thunar = {
      enable = mkDefault true;
      plugins = with pkgs.xfce; mkDefault [
        thunar-volman
        thunar-dropbox-plugin
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };

    # Tumbler for thumbnail support in Thunar
    services.tumbler.enable = mkDefault true;

    # GVFS for Mount, Trash, and other filesystem tools
    services.gvfs.enable = mkDefault true;

    # Xfconf is needed to save thunar's preferences in case XFCE doesn't exist
    # TODO: Eventually pull this into its own module and use home manager for xfconf settings!
    programs.xfconf.enable = mkDefault true;
  };
}
