{ lib, config, ... }:
{
  options.custom.servers = {
    ssh = {
      enable = lib.mkEnableOption "SSHD Server Daemon";
    };
  };

  config = lib.mkIf config.custom.servers.ssh.enable {
    services = {
      openssh.enable = true;
    };
  };
}
