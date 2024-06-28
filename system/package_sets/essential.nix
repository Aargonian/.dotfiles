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
