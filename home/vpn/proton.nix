{ pkgs, ... }:
{
  home.packages = with pkgs; [
    proton-vpn-cli
  ];

  systemd.user.services = {
    proton-vpn = {
      Unit = {
        Description = "Proton VPN";
        PartOf = "sway-session.target";
      };
      Service = {
        Type = "exec";
        ExecStart = "${pkgs.proton-vpn-cli}/bin/protonvpn connect";
        ExecStop = "${pkgs.proton-vpn-cli}/bin/protonvpn disconnect";
        Restart = "on-failure";
        RemainAfterExit = true;
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
  };
}
