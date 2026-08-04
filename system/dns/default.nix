{ pkgs, ... }:
{
  services.stubby = {
    enable = true;
    settings = pkgs.stubby.passthru.settingsExample // {
      upstream_recursive_servers = [
        {
          address_data = "86.54.11.213";
          tls_auth_name = "noads.joindns4.eu";
          tls_pubkey_pinset = [
            {
              digest = "sha256";
              value = "x2GtnWCOXzTIgO8fx3SoHG79Smw9eUGUMrchFTg++nY=";
            }
          ];
        }
        {
          address_data = "86.54.11.13";
          tls_auth_name = "noads.joindns4.eu";
          tls_pubkey_pinset = [
            {
              digest = "sha256";
              value = "x2GtnWCOXzTIgO8fx3SoHG79Smw9eUGUMrchFTg++nY=";
            }
          ];
        }
        {
          address_data = "2a13:1001::86:54:11:13";
          tls_auth_name = "noads.joindns4.eu";
          tls_pubkey_pinset = [
            {
              digest = "sha256";
              value = "x2GtnWCOXzTIgO8fx3SoHG79Smw9eUGUMrchFTg++nY=";
            }
          ];
        }
        {
          address_data = "2a13:1001::86:54:11:213";
          tls_auth_name = "noads.joindns4.eu";
          tls_pubkey_pinset = [
            {
              digest = "sha256";
              value = "x2GtnWCOXzTIgO8fx3SoHG79Smw9eUGUMrchFTg++nY=";
            }
          ];
        }
      ];
    };
  };

  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  # Enable a web browser that bypasses secure DNS.  This is useful for networks that have a
  # captive login page, which is usually implemented as some kind of DNS resolution hack that
  # doesn't work with encrypted DNS.
  programs.captive-browser.enable = true;
}
