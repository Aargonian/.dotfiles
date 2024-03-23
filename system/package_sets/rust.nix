{ pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages =
    (with pkgs; [
      rustup
      ripgrep
      mprocs
      du-dust
      zoxide
      pkgs-unstable.jetbrains.rust-rover
    ])

    ++

    (with pkgs-unstable; [
      jetbrains.rust-rover
    ]);
}
