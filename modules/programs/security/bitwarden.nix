{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.bitwarden.enable = mkEnableOption "Bitwarden password manager";

  config = mkIf config.custom.programs.bitwarden.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        bitwarden-cli
        bitwarden-desktop
      ];
    };
  };
}
