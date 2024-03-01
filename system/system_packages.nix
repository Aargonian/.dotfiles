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
}
