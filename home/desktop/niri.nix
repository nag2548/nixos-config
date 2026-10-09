{ pkgs, ... }:
let
  footToggle = pkgs.writeShellApplication {
    name = "foot-toggle";
    runtimeInputs = [
      pkgs.jq
      pkgs.niri
      pkgs.foot
    ];
    text = ''
      id=$(
        niri msg --json windows \
          | jq -r '
              [ .[] | select((.app_id // "") | startswith("foot")) ]
              | sort_by(.focus_timestamp.secs, .focus_timestamp.nanos)
              | reverse
              | .[0].id // empty
            '
      )
      if [ -n "$id" ]; then
        exec niri msg action focus-window --id "$id"
      else
        exec foot
      fi
    '';
  };
in
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
    footToggle
    swaybg
    xwayland-satellite
  ];
}
