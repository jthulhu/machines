{ pkgs, lib, config, ... }:
with lib;
{
  imports = [
    ./packages.nix
    ./wm
    ./rofi
    ./emacs
    ./sound
    ./pass
    ./gammastep
    ./bash
    ./games
    ./wifi
    ./notifications
    ./fonts
    ./sound
    ./light
    ./utils
    ./discord
    ./firefox
    ./git
    ./python
    ./j
    ./scheme
    ./gtk
    ./mailclient
    ./gpg
    ./network
  ];

  options = {
    xserver = mkOption {
      type = with types; enum [ "wayland" "xorg" ];
      default = "wayland";
      description = ''
The system xserver.
This impacts some utilities (dmenu, ...) and the wm (sway or i3).
'';
    };
  };

  config = let
    inherit (builtins) elem;
    inherit (lib) getName;
    unfreePredicate = pkg: elem (getName pkg) allowedUnfree;
    allowedUnfree = [ "dwarf-fortress" "discord" "minecraft-launcher" "minecraft-server" ];
  in {
    nixpkgs.config.allowUnfreePredicate = unfreePredicate;
    home = {
      stateVersion = "20.09";

      file = {
        ".XCompose".source = ./xcompose;
        ".config/direnv".source = ./direnv;
      };
      
      language = let
        fr = "fr_FR.UTF-8";
        us = "en_US.UTF-8";
      in
        {
          measurement = fr;
          paper = fr;
          monetary = fr;
          time = fr;
          telephone = fr;
          address = fr;
        };
      
      sessionPath = [ "~/.local/bin" ];
      sessionVariables = {
        EDITOR = "emacs";
        XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:$XDG_DATA_DIRS";
        XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      };
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    gtkBookmarks = [
      "prog"
      "em"
      "em/docs"
      "parc"
    ];
    
    fonts.fontconfig.enable = true;

    news.display = "silent";
  };
}
