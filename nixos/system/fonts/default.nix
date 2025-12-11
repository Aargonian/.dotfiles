{ lib, config, pkgs, ... }: with lib;
{
  options.custom.fonts = {
    useNerdFont = mkEnableOption "Common package sets to avoid listing every package individually";
  };

  config = mkIf config.custom.fonts.useNerdFont {
    fonts.packages = with pkgs; [
      nerd-fonts.noto
    ];
  };
}
