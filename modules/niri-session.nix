{ lib, session, ... }:
{
  imports = [
    ./noctalia-greeter.nix
  ];

  programs.niri.enable = lib.mkIf (session == "niri") true;
}
