{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./eww.d;
  };

  services.playerctld.enable = true;
  home.packages = with pkgs; [
    playerctl
  ];
}
