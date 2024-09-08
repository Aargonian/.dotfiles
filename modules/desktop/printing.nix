{lib, config, ...}:
{
  options.custom.printing = {
    enable = lib.mkEnableOption "An IME for Chinese and Japanese Input";
  };

  config = lib.mkIf config.custom.printing.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
