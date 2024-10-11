{ lib, config, ... }: with lib;
{
  options.custom.programs.bash.enable = mkEnableOption "Bash Shell Support";

  config = mkIf config.custom.programs.zsh.enable {
# TODO: Apparently this has no effect. Look into this.
#   programs.bash.enable = true;
  };
}
