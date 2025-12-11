{ lib, config, pkgs, ... }: with lib;
{
  options.custom.system.networking = {
    enable = mkEnableOption "Networking capabilities";

    hostname = mkOption {
      type = types.str;
      description = "Machine hostname. Required for the networking config.";
      example = "NytegearNix";
    };

    vpn.enable = mkEnableOption "MullVad VPN";
  };

  config = mkIf config.custom.system.networking.enable {

    networking = {
      hostName = config.custom.system.networking.hostname;
      networkmanager.enable = mkDefault true;

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      useDHCP = mkDefault true;
      # networking.interfaces.enp5s0.useDHCP = mkDefault true;
      # networking.interfaces.wlo1.useDHCP = mkDefault true;


      firewall.allowedTCPPorts = [];
    };

    time.timeZone = mkDefault "America/New_York";

    environment.systemPackages = with pkgs; [
      dig
      inetutils
    ];


    services = mkIf config.custom.system.networking.vpn.enable {
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
