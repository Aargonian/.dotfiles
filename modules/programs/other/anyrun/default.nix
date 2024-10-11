{ lib, config, pkgs, inputs, ... }: with lib;
{
  options.custom.programs.anyrun.enable = mkEnableOption "Enable anyrun program launcher";

  config = mkIf config.custom.programs.anyrun.enable {
    # Use binary cache for anyrun if possible
    nix.settings = {
      builders-use-substitutes = true;
      extra-substituters = [
        "https://anyrun.cachix.org"
      ];
      extra-trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };

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
