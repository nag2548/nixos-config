{ pkgs, session, ... }:
let
  windowCapture =
    if session == "niri" then "niri msg action screenshot-window" else "noctalia msg screenshot-window";
in
{
  home.packages =
    with pkgs;
    [
      swaybg
      grim
      slurp
      swappy
    ]
    ++ [
      (pkgs.writeShellApplication {
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
              ${windowCapture}
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
      })
    ];
}
