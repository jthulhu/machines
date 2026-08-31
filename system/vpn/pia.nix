{ config, ... }:
{
  services.pia = {
    enable = true;
    authUserPassFile = config.age.secrets.pia-credentials.path;
  };
}
