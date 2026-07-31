{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.tenebrae = nixpkgs.lib.nixosSystem {
        modules = [ ./configuration.nix ];
      };
    };
}
