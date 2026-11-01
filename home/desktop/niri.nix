{ pkgs, ... }:
{
  imports = [
    ./noctalia.nix
  ];

  programs.noctalia.settings.shell = {
    niri_overview_type_to_launch_enabled = true;
    niri_overview_close_on_launch_enabled = true;
  };

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
    xwayland-satellite
  ];
}
