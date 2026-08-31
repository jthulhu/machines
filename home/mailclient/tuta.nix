{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tutanota-desktop
  ];
}
