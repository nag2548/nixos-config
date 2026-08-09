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
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      sops-nix,
      noctalia,
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
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs username; };
              home-manager.sharedModules = [
                sops-nix.homeManagerModules.sops
                noctalia.homeModules.default
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
