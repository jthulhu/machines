{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    thunderbird
  ];
}
