{
  self,
  nixpkgs-stable,
  ...
} @ inputs: {
  hostname,
  system ? "x86_64-linux",
  overlays ? [ ],
}: nixpkgs:
let
  inherit (nixpkgs.lib) nixosSystem;
  custom = {
    my.hostname = hostname;
    nixpkgs.overlays = overlays;
    nix = {
      registry = {
        jpkgs = {
          from = {
            type = "indirect";
            id = "jpkgs";
          };
          flake = nixpkgs;
        };
        stable = {
          from = {
            type = "indirect";
            id = "stable";
          };
          flake = nixpkgs-stable;
        };
      };
    };
  };
  common = "${self}/system/configuration.nix";
  entrypoint = "${self}/system/hosts/${hostname}.nix";
  hardware = "${self}/system/hardware/${hostname}.nix";
in nixosSystem {
  inherit system;
  modules = [
    common
    entrypoint
    hardware
    custom
  ];
}
