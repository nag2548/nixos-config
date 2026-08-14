{ pkgs, ... }:

{
  imports = [
    ./catppuccin.nix
    ./gtk.nix
    ./niri.nix
    ./noctalia.nix
    ./xdg.nix
  ];

  services = {
    polkit-gnome.enable = true;
  };

  home.packages = with pkgs; [
    swaybg
    xwayland-satellite
    nautilus
    xdg-user-dirs-gtk
  ];
}
