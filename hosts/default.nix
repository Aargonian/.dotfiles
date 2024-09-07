{ self, nixpkgs, ...} @ inputs:
let
  inherit (inputs.nixpkgs) lib;
  #system = "x86_64-linux";
  sys-args = {inherit inputs lib; } // { system = "x86_64-linux"; };

  systems = import ./framework sys-args;
in
{
  nixosConfigurations = systems;
}
