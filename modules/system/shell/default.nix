{ lib, pkgs, ... }: with lib;
{
  options.custom.system.shell = {
    package = mkOption {
      type = types.package;
      default = pkgs.zsh;
      example = pkgs.bash;
      description = "Choose a preferred shell program";
    };
  };
}
