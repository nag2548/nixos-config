{ pkgs, ... }:
{
  imports = [
    ./noctalia.nix
  ];

  xdg.configFile."niri/config.kdl".source =
    pkgs.runCommand "niri-config-checked"
      {
        nativeBuildInputs = [ pkgs.niri ];
      }
      ''
        niri validate --config ${../config/niri.kdl}
        cp ${../config/niri.kdl} $out
      '';

  services.polkit-gnome.enable = true;

  home.packages = with pkgs; [
    nirius
    swaybg
    xwayland-satellite
  ];
}
