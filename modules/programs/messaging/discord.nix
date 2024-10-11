{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.discord.enable = mkEnableOption "Discord Chat Client";

  config = mkIf config.custom.programs.discord.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        discord
      ];

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };
}
