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

  # GNOME Keyring is the Secret Service provider behind the keyring
  # prompts (noctalia storage/calendar, nextcloud, protonmail bridge).
  # The niri module in nixpkgs enables this with `mkDefault`, but umbriel
  # replaces the nixpkgs wayland module, so nothing enables it here.
  # `enableGnomeKeyring` adds pam_gnome_keyring to the login stack, which
  # unlocks the "Login" keyring with the login password.
  services.gnome.gnome-keyring.enable = lib.mkIf (session == "umbriel") true;

  # gnome-keyring ships the `org.freedesktop.impl.portal.Secret` backend,
  # so it has to be part of the umbriel portal's backend list.
  xdg.portal.config.umbriel.default = lib.mkIf (session == "umbriel") [
    "umbriel"
    "gtk"
    "gnome-keyring"
  ];
}
