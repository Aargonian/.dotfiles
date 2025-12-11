{ lib, config, pkgs, ... }:
{
  # An Ebook Reader that is actually very nice...
  options.custom.programs.foliate.enable = lib.mkEnableOption "Foliate Ebook Reader";

  config = lib.mkIf config.custom.programs.foliate.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        foliate
      ];
    };
  };
}
