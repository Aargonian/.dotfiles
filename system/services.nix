{ pkgs, lib, ... }:
{
  # Recommended for Pipewire and Pulseaudio
  security.rtkit.enable = true;

  services = {
    openssh.enable = true;
    gvfs = {
      enable = true;
      package = lib.mkForce pkgs.gnome3.gvfs;
    };

    # iPhone Connection Capability
    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };

    # Pipewire for Audio and Screensharing
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber = {
        enable = true;
      };
    };
  };

  # Start and Auto-Run Thunderbird
  #systemd.user.services = {
  #  thunderbird = {
  #    enable = true;
  #    unitConfig = {
  #  Description = "Thunderbird!";
  #  After = [ "network.target" ];
  #  StartLimitIntervalSec = 300;
  #  StartLimitBurst = 5;
  #    };
  #    serviceConfig = {
  #      Type = "simple";
  #  ExecStart = ["${pkgs.thunderbird}/bin/thunderbird --headless"];
  #  Restart = "always";
  #  RestartSec = "1s";
  #    };
  #    wantedBy = [ "default.target" ];
  #  };
  #};

  # Polkit
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
