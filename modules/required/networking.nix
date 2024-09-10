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
      networkmanager.enable = lib.mkDefault true;

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      useDHCP = lib.mkDefault true;
      # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;


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
