{lib, pkgs, config, ...}:
{
  options.custom.development.rust = {
    enable = lib.mkEnableOption "Rust development tools";
  };

  config = lib.mkIf config.custom.development.rust.enable {
    environment.systemPackages = with pkgs; [
      cargo
      rustup
      ripgrep
    ];

    # TODO: Make a nix shell to solve this issue
    # Bad bad dirty hack to make generic linux binaries work
    programs.nix-ld.enable = true;
    #programs.nix-ld.libraries = config.programs.nix-ld.libraries.default ++ (with pkgs; [
    #  stdenv.cc.cc
    #  xorg.libX11
    #  xorg.libXcursor
    #  xorg.libxcb
    #  xorg.libXi
    #  libxkbcommon
    #]);
  };
}
