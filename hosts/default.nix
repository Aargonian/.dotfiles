{ self, ...} @ inputs:
let
  inherit (inputs.nixpkgs) lib;
  config-path = "${self}/modules";

  system-args = {
    inherit lib;
    inherit inputs;
    inherit config-path;
  };

  systems = {
    x86_64-linux = import ./x86_64-linux system-args;
  };
  nixosSystems = builtins.attrValues systems;
in
{
  nixosConfigurations = lib.attrsets.mergeAttrsList (map (system: system.nixosConfigurations or {}) nixosSystems);
}
