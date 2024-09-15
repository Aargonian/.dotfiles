{ lib, config, inputs, pkgs, ... }:
{
  options.custom.anyrun = {
    enable = lib.mkEnableOption "Enable anyrun program launcher";
  };

  config = lib.mkIf config.custom.anyrun.enable {
    home-manager.users.${config.custom.username} = {
      imports = [
        inputs.anyrun.homeManagerModules.default
      ];

      programs.anyrun = {
        enable = true;
        config = {
          plugins = with inputs.anyrun.packages.${pkgs.system}; [
            applications
            rink
            # randr
            shell
            kidex
            symbols
          ];

          width.fraction = 0.25;
          y.fraction = 0.3;
          hidePluginInfo = true;
          closeOnClick = true;
          hideIcons = false;
          showResultsImmediately = true;
          maxEntries = null;
        };

        extraCss = builtins.readFile(./. + "/anyrun-style.css");
      };
    };
  };
}
