{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.development.nix.all = mkEnableOption "Nix Development Utilities";

  config = mkIf config.custom.programs.development.nix.all {
    environment.systemPackages = with pkgs; [
      nil         # Nix Language Server
    ];
  };
}
