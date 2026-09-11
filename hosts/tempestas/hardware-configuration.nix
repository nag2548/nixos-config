{
  nixpkgs.hostPlatform = "x86_64-linux";

  assertions = [
    {
      assertion = false;
      message = "hosts/tempestas/hardware-configuration.nix is a placeholder. Run `nixos-generate-config` on the target machine and replace this file before building.";
    }
  ];
}
