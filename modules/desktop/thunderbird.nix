{lib, pkgs, config, ...}:
{
  options.custom.desktop.programs.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird Email Client";
  };

  config = lib.mkIf config.custom.desktop.programs.thunderbird.enable {
    environment.systemPackages = with pkgs; [
      thunderbird
    ];
  };
}
