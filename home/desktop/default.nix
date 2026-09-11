{ pkgs, ... }:
{
  imports = [
    ./catppuccin.nix
    ./gtk.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    nautilus
    xdg-user-dirs-gtk
  ];
}
