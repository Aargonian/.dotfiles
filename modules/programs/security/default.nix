{ lib, config, ... }: with lib;
{
  imports = [
    ./bitwarden.nix
    ./keyring.nix
  ];

  options.custom.programs.security.all = mkEnableOption "All security programs";

  config = mkIf config.custom.programs.security.all {
    custom.system.display.enable = true;
    custom.programs = {
      security = {
        keyring.enable = mkDefault true;
      };

      bitwarden.enable = true;
    };
  };
}
