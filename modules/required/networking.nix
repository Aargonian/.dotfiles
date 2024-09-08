{ lib, pkgs, config, ... }:
{
  options.custom = {
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Machine hostname. Required for the networking config.";
      example = "NytegearNix";
    };

    mullvad = {
      enable = lib.mkEnableOption "MullVad VPN";
    };
  };

  config = {
    networking = {
      hostName = config.custom.hostname;
      networkmanager.enable = true;
      firewall.allowedTCPPorts = [];
    };

    time.timeZone = lib.mkDefault "America/New_York";

    environment.systemPackages = with pkgs; [
      dig
      inetutils
    ];


    services = lib.mkIf config.custom.mullvad.enable {
      mullvad-vpn.enable = true;

      # Mullvad currently requires systemd-resolved
      resolved = {
        enable = true;
        dnssec = "false";
        dnsovertls = "false";
      };
    };
  };
}
