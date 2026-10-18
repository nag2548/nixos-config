{ pkgs, ... }:

let
  nshot = pkgs.writeShellApplication {
    name = "nshot";
    runtimeInputs = with pkgs; [
      grim
      slurp
      swappy
      wl-clipboard
      coreutils
    ];
    text = ''
      set -euo pipefail

      dir="$HOME/Pictures/Screenshots"
      mkdir -p "$dir"
      target="$dir/Screenshot from $(date +%Y-%m-%d\ %H-%M-%S).png"

      case "''${1:-}" in
        region)
          grim -g "$(slurp)" - | swappy -f - -o "$target"
          ;;
        region-copy)
          grim -g "$(slurp)" "$target"
          swappy -f "$target" -o "$target"
          wl-copy < "$target"
          ;;
        window)
          niri msg action screenshot-window
          sleep 0.2
          # shellcheck disable=SC2012
          latest=$(ls -t "$dir"/*.png 2>/dev/null | head -1 || true)
          if [ -n "''${latest:-}" ]; then
            swappy -f "$latest" -o "$latest"
          fi
          ;;
        *)
          echo "usage: nshot {region|region-copy|window}" >&2
          exit 1
          ;;
      esac
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

  home.packages =
    with pkgs;
    [
      nirius
      swaybg
      xwayland-satellite
      grim
      slurp
      swappy
    ]
    ++ [ nshot ];
}
