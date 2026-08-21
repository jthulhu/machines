{ pkgs, ... }:
{
  services.protonmail-bridge = {
    enable = true;
    logLevel = "debug";
    extraPackages = with pkgs; [
      oo7
    ];
  };
  
  systemd.user.services.protonmail-bridge = {
    Service = {
      Environment = [
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/%U/bus"
        "PROTONMAIL_BRIDGE_KEYCHAIN=secret-service"
      ];
    };
  };
}
