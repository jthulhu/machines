{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str listOf;
in
{
  imports = [
    ./bash
    ./boot
    ./cachix.nix
    ./dbus
    ./ecryptfs
    ./evscript
    ./firewall
    ./fonts
    ./fs
    ./git
    ./gpu
    ./greeter
    ./layouts
    ./locate
    ./man
    ./network
    ./nix
    ./lang
    ./presets.nix
    ./sound
    ./steam
    ./users
    ./utils
    ./vm
    ./yubico
  ];

  options.my = {
    hostname = mkOption {
      type = str;
      description = "The system hostname.";
    };
    unfree = mkOption {
      type = listOf str;
      description = "List of unfree packages installed.";
      default = [ ];
      example = ''[ "steam" ]'';
    };
  };

  config = let
    inherit (lib) getName mkDefault mkIf;
    inherit (builtins) elem;
    inherit (config) my;
  in {
    nixpkgs.config = {
      allowUnfreePredicate = pkg: elem (getName pkg) my.unfree;
      permittedInsecurePackages = [
        "python-2.7.18.6"
      ];
    };

    services.emacs.defaultEditor = true;

    services.openssh.enable = true;

    networking.hostName = my.hostname;

    time.timeZone = mkDefault "Europe/Paris";

    networking.useDHCP = false;

    console = {
      font = "Lat2-Terminus16";
    };

    services = {
      printing.enable = true;
    };

    system.stateVersion = "20.09";
  };
}
