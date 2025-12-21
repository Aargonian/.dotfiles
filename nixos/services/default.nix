{ ... }:
{
  imports = [
    ./avahi.nix
    ./fprintd.nix
    ./greetd.nix
    ./lact.nix
    ./picom.nix
    ./pipewire.nix
    ./polkit.nix
    ./power-profiles-daemon.nix
    ./wireguard.nix
  ];

  # Knot DNS Resolver
  services.kresd.enable = false;

  # Disable built-in DNS
  #services.resolved.enable = false;

  #environment.etc."resolv.conf" = {
  #  mode = "0644";
  #  text = "nameserver ::1";
  #};
}
