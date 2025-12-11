{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.printing = {
    enable = mkEnableOption "An IME for Chinese and Japanese Input";
  };

  config = mkIf config.custom.programs.printing.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
