{ lib, config, ... }: with lib;
{
  options.custom.servers = {
    ssh = {
      enable = mkEnableOption "SSHD Server Daemon";
    };
  };

  config = mkIf config.custom.servers.ssh.enable {
    services = {
      openssh.enable = true;
    };
  };
}
