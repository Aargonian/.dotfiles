{ lib, pkgs, config, ...}:
{
  options.custom.desktop.programs.thunar = {
    enable = lib.mkEnableOption "Thunar File Manager";
  };

  config = lib.mkIf config.custom.desktop.programs.thunar.enable {
    # Necessary for thunar to mount external drives correctly
    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [
      xfce.thunar
    ];
  };
}
