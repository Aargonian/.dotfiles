{ lib, inputs, config-path, ... } @ system-args:
let
  system-name = "x86_64-linux";
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
    (import ./framework { inherit host-args; })
#   (import ./desktop { inherit host-args; })
  ];
in
{
#  nixosConfigurations = lib.attrsets.mergeAttrsList systems;
  nixosConfigurations = import ./framework host-args;
}
