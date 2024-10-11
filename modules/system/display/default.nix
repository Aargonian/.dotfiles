{ lib, config, ... }: with lib;
{
  imports = [
    ./desktopManagers
    ./wayland
    ./windowManagers
    ./xorg

    ./displaylink.nix
    ./theme.nix
  ];

  options.custom.system.display = {
    enable = mkEnableOption "General Display Capabilities";
  };

  config = mkIf config.custom.system.display.enable {

    # Disable SDDM by default
    services.displayManager.sddm.enable = mkDefault false;
  };
}
