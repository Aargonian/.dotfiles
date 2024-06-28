{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    file
    cifs-utils
    gnome.gvfs
    htop
    nmon

    # iPhone Connection
    libimobiledevice
    ifuse
    idevicerestore

    # Build Tools
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
    dualsensectl
    udisks
    parted
  ];
}
