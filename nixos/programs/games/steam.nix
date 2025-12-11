{ lib, config, ... }: with lib;
{
  options.custom.programs.steam = {
    enable = mkEnableOption "Steam and Steam Runtime";
  };

  config = mkIf config.custom.programs.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = mkDefault true;
      dedicatedServer.openFirewall = mkDefault true;
    };
  };
}
