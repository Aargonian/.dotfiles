{ lib, config, ... }: with lib;
{
  options.custom.system.virtualization.virtualbox = {
    host = mkEnableOption "Host virtualbox System";
    guest = mkEnableOption "Guest virtualbox System";
  };

  config = {
   virtualisation.virtualbox.host.enable = config.custom.system.virtualization.virtualbox.host;

   users.extraGroups.virtualboxusers.members = mkIf config.custom.system.virtualization.virtualbox.host [
     config.custom.username
   ];
  };
}
