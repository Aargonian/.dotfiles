{ lib, config, ... }: with lib;
{
  imports = [
    ./common.nix
    ./git.nix
    ./javascript.nix
    ./python.nix
    ./rust.nix
    ./nix.nix
  ];

  options.custom.programs.development.all = mkEnableOption "All Development Programs";

  config = mkIf config.custom.programs.development.all {
    custom.programs = {
      development = {
        common.all = true;
        python.all = true;
        javascript.all = true;
        rust.all = true;
        nix.all = true;
      };

      git.enable = true;
    };
  };
}
