{ pkgs, ... }:
{
  home.packages = with pkgs; [
    anki-bin
    mpv
  ];
}