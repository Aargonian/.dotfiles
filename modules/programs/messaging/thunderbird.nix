{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.thunderbird = {
    enable = mkEnableOption "Thunderbird Email Client";
  };

  config = mkIf config.custom.programs.thunderbird.enable {
    environment.systemPackages = with pkgs; [
      thunderbird
    ];
  };
}
