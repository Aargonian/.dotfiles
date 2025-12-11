{ lib, config, pkgs, ... }: with lib;
{
  options.custom.services.lact.enable = mkEnableOption "LACT AMD GPU Control and Monitor";

  config = mkIf config.custom.services.lact.enable {
    environment.systemPackages = with pkgs; [
      lact
    ];

    # Control AMD GPU with Lact
    systemd.packages = [ pkgs.lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  };
}
