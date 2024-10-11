{ lib, config, ... }: with lib;
{
  imports = [
    ./common.nix
    ./git.nix
    ./javascript.nix
    ./neovim.nix
    ./python.nix
    ./rust.nix
  ];

  options.custom.programs.development.all = mkEnableOption "All Development Programs";

  config = mkIf config.custom.programs.development.all {
    custom.programs = {
      development = {
        common.all = true;
        python.all = true;
        javascript.all = true;
        rust.all = true;
      };

      git.enable = true;
      neovim.enable = true;
    };
  };
}
