{ lib, config, ... }: with lib;
{
  options.custom.services.avahi.enable = mkEnableOption "Avahi Zeroconf Service";

  config = mkIf config.custom.services.avahi.enable {
    networking.firewall.allowedTCPPorts = [
      548
      636
    ];

    services.avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
        addresses = true;
      };
    };
  };
}
