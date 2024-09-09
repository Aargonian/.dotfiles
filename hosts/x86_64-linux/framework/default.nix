{ lib, inputs, pkgs-stable, pkgs-unstable, system-name, config-path, ... } @ host-inputs:
{
  framework = lib.nixosSystem {
    system = system-name;
    modules = [
      config-path
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd

      ./config.nix
    ];
    specialArgs = {
      inherit inputs;
      inherit pkgs-unstable;

      username = "aargonian";
      hostname = "NytegearFramework";
    };
  };
}
