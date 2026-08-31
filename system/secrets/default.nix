{ pkgs, config, lib, ... }:
let
  inherit (lib.attrsets) mapAttrs';
  inherit (config.my) hostname;
  inherit (lib.strings) removeSuffix;
  secrets = import ../../secrets/secrets.nix;
in {
  environment.systemPackages = with pkgs; [
    rage
    ragenix
  ];
  age = {
    secrets = mapAttrs' (file: _: { 
      name = removeSuffix ".age" file;
      value.file = ../../secrets/${file}; 
    }) secrets;
    identityPaths = [
      "/var/lib/rage/${hostname}.priv"
    ];
  };
}
