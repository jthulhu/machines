{ config, ... }:
{
  services.pia = {
    enable = true;
    credentials.credentialsFile = config.age.secrets.pia-credentials.path;
    protocol = "wireguard";
    autoConnect = {
      enable = true;
      region = "france";
    };
  };
}
