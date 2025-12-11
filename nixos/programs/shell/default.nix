{ lib, config, pkgs, ... }: with lib;
{
  imports = [
    ./bash.nix
    ./common.nix
    ./zsh.nix
  ];

  options.custom.programs.shell.all = mkEnableOption "All shell utility programs.";

  config = mkIf config.custom.programs.shell.all {
    custom.programs = {
      shell = {
        common.all = true;
      };

      zsh.enable = true;
      bash.enable = true;
    };
  };
}
