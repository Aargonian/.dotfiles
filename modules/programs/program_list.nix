{ config, pkgs, lib, ...}:
let
  addProgram = name: requiredCapabilities: extraConfig: {
    options.custom.programs_list.${name} = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ${name}";
    };

    config = lib.mkIf
    (
         (config.custom.programs.${name} or false)
      && (builtins.all (capability: config.capabilities.${capability}.available or false) requiredCapabilities)
    )
    (
        { environment.systemPackages = [ pkgs.${name} ]; }
        // extraConfig
    );
  };

  firefox = addProgram "firefox" [ "display" ];
in
{
  imports = [
    firefox
  ];
}
