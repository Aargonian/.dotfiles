{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.thunderbird = {
    enable = mkEnableOption "Thunderbird Email Client";
  };

  #onfig = mkIf config.custom.programs.thunderbird.enable {
  # home-manager.users.${config.custom.username} = {
  #   programs.thunderbird = {
  #     enable = true;
  #   };
  # };

  # # TODO: Use home manager to set up thunderbird profile after adjusting settings where I want!
  #;
}
