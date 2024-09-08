{ self, nixpkgs, ...} @ inputs:
let
  inherit (inputs.nixpkgs) lib;

  additional_inputs = {
    config-path = "${self}/modules";
    system = "x86_64-linux";
  };

  sys-args = {inherit inputs lib; } // additional_inputs;
  systems = import ./framework sys-args;
in
{
  nixosConfigurations = systems;
}
