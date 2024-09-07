{ lib, inputs, system, ... }:
{
  framework = lib.nixosSystem {
    inherit system;
    modules = [
      ./framework-config.nix
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ];
    specialArgs = {
      inherit inputs;
      inherit (inputs.pkgs-unstable) pkgs-unstable;

      username = "aargonian";
      hostname = "NytegearFramework";
    };
  };
}
