{ lib, inputs, system, config-path, ... }:
{
  framework = lib.nixosSystem {
    inherit system;
    modules = [
      config-path
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd

      ./config.nix
    ];
    specialArgs = {
      inherit inputs;
      inherit (inputs.pkgs-unstable) pkgs-unstable;

      username = "aargonian";
      hostname = "NytegearFramework";
    };
  };
}
