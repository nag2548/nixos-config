{ pkgs, ... }:
let
  # xwayland-satellite with _NET_WM_FULLSCREEN_MONITORS support, applied on
  # top of the nixpkgs release.
  # https://github.com/Supreeeme/xwayland-satellite/pull/550
  xwayland-satellite-fullscreen-monitors = pkgs.xwayland-satellite.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        url = "https://github.com/Supreeeme/xwayland-satellite/commit/232e5eb96cdbd7cc7c744dce17d8994a42fe2326.patch";
        hash = "sha256-44PG/BDx2HrE06gqJj02k50r0IIinCdL2qBBcStVcaA=";
      })
    ];
  });
in
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
    xwayland-satellite-fullscreen-monitors
  ];
}
