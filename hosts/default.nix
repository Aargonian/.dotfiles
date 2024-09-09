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

  _traceInputs = builtins.trace "Inputs: ${builtins.toJSON inputs}";
  _traceValues = builtins.trace "Systems: ${builtins.toJSON systems}";
in
{
# nixosConfigurations = systems;
# nixosConfigurations = lib.attrsets.mergeAttrsList (map (system: system.nixosConfigurations or {}) systems);
  nixosConfigurations = lib.attrsets.mergeAttrsList (map (system: system.nixosConfigurations or {}) nixosSystems);
}
#{ self, inputs, ...}:
#let
#  inherit (inputs.nixpkgs) lib;
#  config-path = "${self}/modules";
#  system-name = "x86_64-linux";
#  system-package-args = {
#    inherit (inputs.nixpkgs) lib;
#    inherit config-path;
#    inherit system-name;
#
#    # Stable Package Set
#    system = import inputs.nixpkgs {
#      system = inputs.system-name;
#      config = {
#        allowUnfree = true;
#        allowUnfreePredicate = (_: true);
#      };
#    };
#
#    # Unstable Package Set
#    pkgs-unstable = import inputs.nixpkgs-unstable {
#      system = inputs.system-name;
#      config = {
#        allowUnfree = true;
#        allowUnfreePredicate = (_: true);
#      };
#    };
#  };
#
#  system-args = inputs // system-package-args;
#
#  systems = [
#    (import ./framework { inherit system-args; })
##   (import ./desktop { inherit system-args; })
#  ];
#in
#{
#  nixosConfigurations = lib.attrsets.mergeAttrsList systems;
#}
