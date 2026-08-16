{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
}
