{ hostname, ... }:
{
  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.firewall.allowedTCPPorts = [ 22 ];
  time.timeZone = "America/New_York";

  # Setup Mullvad VPN
  services.mullvad-vpn.enable = true;

  # Mullvad currently requires systemd-resolved
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
  };
}
