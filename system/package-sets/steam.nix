{ pkgs, ... }:
{
  # Steam has to be installed globally due to the following: https://github.com/nix-community/home-manager/issues/4314
  # Essentially, there is no user-specific way to install the required OpenGL packages
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Allow unfree packages for steam
  nixpkgs.config.allowUnfree = true;
}
