{ lib, config, ... }: with lib;
{
  options.custom.system.bluetooth.enable = mkEnableOption "Bluetooth capability";
}
