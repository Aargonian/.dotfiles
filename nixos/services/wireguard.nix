{ ... }:
{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [
        "10.0.0.104/32"
      ];

      dns = [ "10.0.0.1" ];
      privateKey = "EM2pUUgGCh1Dbsm8NxEJ5wRrnHpszhhXR/qrJAp9/G8=";
      peers = [
        {
          publicKey = "JnOZUV+TQTQpDlbzmaFuW8PwrmJaI7eLqd4ovtjKI14=";
          allowedIPs = [
            "10.0.0.0/8"
          ];
          endpoint = "nytework.access.ly:587";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
