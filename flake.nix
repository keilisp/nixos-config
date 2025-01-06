{
  description = "A grossly incandescent nixos config.";

  inputs = 
    {
      # Core dependencies.
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";                  # primary nixpkgs
      # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";      # for packages on the edge
      # home-manager.url = "github:nix-community/home-manager";

      home-manager.url = "github:nix-community/home-manager/release-24.11";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixpkgs";

      # Extras
      emacs-overlay.url  = "github:nix-community/emacs-overlay";
      nixos-hardware.url = "github:nixos/nixos-hardware";
      kmonad.url = "github:kmonad/kmonad?dir=nix";
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;  # forgive me Stallman senpai
        # config.allowBroken = true; 
        config.permittedInsecurePackages = [
          "qtwebkit-5.212.0-alpha4" # for pobfrontend
          "openssl-1.1.1t" # https://www.openssl.org/blog/blog/2023/03/28/1.1.1-EOL/
          "zotero-6.0.27"
          "docker-24.0.9"
        ];
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      pkgs  = mkPkgs nixpkgs [ self.overlay ];
      pkgs' = mkPkgs nixpkgs-unstable [];

      lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
    in {
      lib = lib.my;

      overlay =
        final: prev: {
          unstable = pkgs';
          my = self.packages."${system}";
        };

      overlays =
        mapModules ./overlays import;

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p {});

      nixosModules =
        { dotfiles = import ./.; } // mapModulesRec ./modules import;

      nixosConfigurations =
        mapHosts ./hosts {};

      devShell."${system}" =
        import ./shell.nix { inherit pkgs; };

      templates = {
        full = {
          path = ./.;
          description = "A grossly incandescent nixos config";
        };
        minimal = {
          path = ./templates/minimal;
          description = "A grossly incandescent and minimal nixos config";
        };
      };
      defaultTemplate = self.templates.minimal;

      defaultApp."${system}" = {
        type = "app";
        program = ./bin/hey;
      };
    };
}

