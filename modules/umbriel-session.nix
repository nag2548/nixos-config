{
  inputs,
  lib,
  session,
  ...
}:
{
  imports = [
    ./noctalia-greeter.nix
    inputs.umbriel.nixosModules.default
  ];

  programs.umbriel.enable = lib.mkIf (session == "umbriel") true;

  # Umbriel starts the wlroots Xwayland server itself and looks the
  # `Xwayland` binary up on PATH, so the package has to be installed.
  programs.xwayland.enable = lib.mkIf (session == "umbriel") true;
}
