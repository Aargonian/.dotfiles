{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.zsh.enable = mkEnableOption "ZSH Shell Support";

  config = mkIf config.custom.programs.zsh.enable {
    programs.zsh.enable = true;
  };
}
