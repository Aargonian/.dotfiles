{ hostname, ... }:
{
  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.firewall.allowedTCPPorts = [ 22 ];
  time.timeZone = "America/New_York";
}
