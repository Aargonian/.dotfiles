{ lib, inputs, ... }:
{
  framework = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./framework-config.nix
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ];
    specialArgs = {
      inherit inputs;

      username = "aargonian";
      hostname = "NytegearFramework";
      pkgs-unstable = inputs.pkgs-unstable;
    };
  };
}
