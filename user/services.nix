{ pkgs, ... }:
{
  # Start and Auto-Run Thunderbird
  systemd.user.services = {
    thunderbird = {
      unitConfig = {
        Description = "Thunderbird!";
        After = [ "network.target" ];
        StartLimitIntervalSec = 300;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = ["${pkgs.thunderbird}/bin/thunderbird"];
        Restart = "always";
        RestartSec = "1s";
      };
      install = {
        wantedBy = [ "default.target" ];
      };
    };
  };
}
