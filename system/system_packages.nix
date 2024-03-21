{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    file
    cifs-utils
    samba
    gnome.gvfs
    git
    cmakeMinimal
    gcc
    gnumake
    rustup
    python3
    ripgrep
    mprocs
    du-dust
    zoxide
  ];

  # Steam has to be installed globally due to the following: https://github.com/nix-community/home-manager/issues/4314
  # Essentially, there is no user-specific way to install the required OpenGL packages
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
