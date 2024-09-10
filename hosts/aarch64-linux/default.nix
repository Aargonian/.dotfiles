{ lib, inputs, config-path, ... }:
let
  system-name = "aarch64-linux";
  host-args = {
    inherit inputs;
    inherit lib;
    inherit config-path;
    inherit system-name;

    # Stable Package Set
    pkgs-stable = import inputs.nixpkgs {
      system = system-name;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    # Unstable Package Set
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = system-name;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };
  };

  systems = [
    (import ./rpi host-args)
    (import ./paravm host-args)
  ];
in
{
  nixosConfigurations = lib.attrsets.mergeAttrsList systems;
}
