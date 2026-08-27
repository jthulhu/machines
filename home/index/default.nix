{ pkgs, ... }:
{
  programs.nix-index = {
    enable = true;
    package = pkgs.small-nix-index;
  };
  
  programs.nix-index-database = {
    comma.enable = true;
  };
}
