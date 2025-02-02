{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.development.rust.all = mkEnableOption "Rust development tools";

  config = mkIf config.custom.programs.development.rust.all {
    environment.systemPackages = with pkgs; [
      # cargo
      # rustc
      #ripgrep
      rustup
    ];

    # TODO: Make a nix shell to solve this issue
    # Bad bad dirty hack to make generic linux binaries work
#   programs.nix-ld.enable = true;
#   programs.nix-ld.libraries = config.programs.nix-ld.libraries.default ++ (with pkgs; [
#     stdenv.cc.cc
#     xorg.libX11
#     xorg.libXcursor
#     xorg.libxcb
#     xorg.libXi
#     libxkbcommon
#   ]);
  };
}
