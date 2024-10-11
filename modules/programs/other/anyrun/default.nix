{ lib, config, pkgs, inputs, ... }: with lib;
{
# TODO: Anyrun appears to be borked in new config. Figure out why.
# imports = [
#   inputs.anyrun.homeManagerModules.default
# ];

  options.custom.programs.anyrun.enable = mkEnableOption "Enable anyrun program launcher";

# config = mkIf config.custom.programs.anyrun.enable {
#   home-manager.users.${config.custom.username} = {
#     programs.anyrun = {
#       enable = true;
#       config = {
#         plugins = with inputs.anyrun.packages.${pkgs.system}; [
#           applications
#           rink
#           # randr
#           shell
#           kidex
#           symbols
#         ];

#         width.fraction = 0.25;
#         y.fraction = 0.3;
#         hidePluginInfo = true;
#         closeOnClick = true;
#         hideIcons = false;
#         showResultsImmediately = true;
#         maxEntries = null;
#       };

#       extraCss = builtins.readFile(./. + "/anyrun-style.css");
#     };
#   };
# };
}
