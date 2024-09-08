{ lib, ...}:
{
  # These packages cannot be disabled as I've determined they are necessary on all my systems.
  imports = [
    ./boot.nix
    ./common.nix
    ./users.nix
    ./shell.nix
    ./networking.nix
  ];
}
