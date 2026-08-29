{
  description = "My own, very basic NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://cache.keyruu.de"
      "https://cache.nixos.org"
      "https://vicinae.cachix.org"
      "https://noctalia.cachix.org"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://catppuccin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.keyruu.de:BifJnHe/XQhZmmFwLSZttthsXT4u2/L4aeo0k9zV+Kc="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      sops-nix,
      noctalia,
      noctalia-greeter,
      vicinae,
      catppuccin,
      nvf,
      ...
    }:
    let
      username = "nadine";
      mkHost =
        hostPath:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username; };

          modules = [
            hostPath
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            noctalia-greeter.nixosModules.default
            vicinae.nixosModules.default
            catppuccin.nixosModules.catppuccin

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs username; };
              home-manager.sharedModules = [
                sops-nix.homeManagerModules.sops
                noctalia.homeModules.default
                vicinae.homeManagerModules.default
                catppuccin.homeModules.catppuccin
                nvf.homeManagerModules.default
              ];
              home-manager.users.${username} = {
                imports = [ ./home ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        tenebrae = mkHost ./hosts/tenebrae;
        galanthus = mkHost ./hosts/galanthus;
      };
    };
}
