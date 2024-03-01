{ pkgs, lib, ... }:
{
  # List services that you want to enable:
  services.openssh.enable = true;
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome3.gvfs;
  };

  # Start and Auto-Run Thunderbird
  systemd.user.services = {
    thunderbird = {
      enable = true;
      unitConfig = {
    Description = "Thunderbird!";
    After = [ "network.target" ];
    StartLimitIntervalSec = 300;
    StartLimitBurst = 5;
      };
      serviceConfig = {
        Type = "simple";
    ExecStart = ["${pkgs.thunderbird}/bin/thunderbird --headless"];
    Restart = "always";
    RestartSec = "1s";
      };
      wantedBy = [ "default.target" ];
    };
  };
}
