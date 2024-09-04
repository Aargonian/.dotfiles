{ pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    rustup
    ripgrep
    mprocs
    du-dust
    zoxide
  ];
}
