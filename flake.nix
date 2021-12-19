{
  description = "Full BB configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    homeManager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rustOverlay.url = github:oxalica/rust-overlay;
    emacsOverlay.url = github:nix-community/emacs-overlay;
  };

  outputs = { self, nixpkgs, homeManager, rustOverlay, emacsOverlay }: {
    homeConfigurations = let
      inherit (homeManager.lib) homeManagerConfiguration;
      overlaysModule = {
        nixpkgs.overlays = [
          rustOverlay.overlay
          emacsOverlay.overlay
        ];
      };
    in {
      "adri@dragonbreath" = homeManagerConfiguration rec {
        username = "adri";
        homeDirectory = "/home/${username}";
        configuration = ./home/home.nix;
        extraModules = [
          ./home/hosts/dragonbreath.nix
          overlaysModule
        ];
      };
      "adri@cthulhu" = homeManagerConfiguration rec {
        username = "adri";
        homeDirectory = "/home/${username}";
        configuration = ./home/home.nix;
        extraModules = [
          ./home/hosts/cthulhu.nix
          overlaysModule
        ];
      };
    };
    nixosConfigurations = with nixpkgs.lib; {
      dragonbreath = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          ./system/hosts/dragonbreath.nix
        ];
      };
      cthulhu = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          ./system/hosts/cthulhu.nix
        ];
      };
    };
  };
}
