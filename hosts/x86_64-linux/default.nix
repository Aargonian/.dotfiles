{ lib, inputs, config-path, users-path, ... }:
let
  system-name = "x86_64-linux";
  host-args = {
    inherit inputs;
    inherit lib;
    inherit config-path;
    inherit users-path;
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
    (import ./framework host-args)
    (import ./desktop host-args)
  ];
in
{
  nixosConfigurations = lib.attrsets.mergeAttrsList systems;
}
