{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dolphin
    konsole
    spectacle
  ];
}
