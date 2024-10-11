{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.bash.enable = mkEnableOption "Bash Shell Support";

  config = mkIf config.custom.programs.zsh.enable {
    environment.systemPackages = with pkgs; [
      bash
    ];
  };
}
