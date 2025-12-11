{ self, ...} @ inputs:
let
  inherit (inputs.nixpkgs) lib;
  config-path = "${self}/nixos";
  profiles-path = "${self}/home";

  system-args = {
    inherit lib;
    inherit inputs;
    inherit config-path;
    inherit profiles-path;
  };

  systems = {
    x86_64-linux = import ./x86_64-linux system-args;
  };
  nixosSystems = builtins.attrValues systems;
in
{
  nixosConfigurations = lib.attrsets.mergeAttrsList (map (system: system.nixosConfigurations or {}) nixosSystems);
}
