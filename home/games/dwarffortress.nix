{ lib, pkgs, config, ... }:
let
  inherit (lib) mkOption types optional;
  dwarfFortress =
    pkgs.dwarf-fortress.override {
      theme = pkgs.stable.dwarf-fortress-packages.themes.vettlingr;
      enableDFHack = true;
      enableTWBT = true;
      enableSound = false;
      enableIntro = false;
    };
in
{
  options.games.dwarfFortress = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = with config; {
    home.packages = optional games.dwarfFortress.enable dwarfFortress;
  };
}
