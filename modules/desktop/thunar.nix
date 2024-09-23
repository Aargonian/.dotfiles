{ lib, pkgs, config, ...}:
{
  options.custom.desktop.programs.thunar = {
    enable = lib.mkEnableOption "Thunar File Manager";
  };

  config = lib.mkIf config.custom.desktop.programs.thunar.enable {
    programs.thunar.enable = true;

    programs.thunar.plugins = lib.mkDefault [
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-media-tags-plugin
      pkgs.xfce.thunar-volman
    ];

    # Needed to save preferences without XFCE
    programs.xfconf.enable = lib.mkDefault true;

    services.gvfs.enable = lib.mkDefault true; # Mount, trash, and other functionalities
    services.tumbler.enable = lib.mkDefault true; # Thumbnail support



    environment.systemPackages = with pkgs; [
      xfce.thunar
    ];
  };
}
