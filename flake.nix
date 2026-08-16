{
  description = "My own, very basic NixOS configuration";

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
            nvf.nixosModules.default
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
