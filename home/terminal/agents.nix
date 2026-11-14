{ pkgs, lib, ... }:
let
  caveman = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "b4ee71d557d96e3cbc14f88fa6e953a1362865f5";
    hash = "sha256-HcNc+iyIL/K4JOBBsJAS2eh0vcpW3CwL5CQMqY0LMh0=";
  };

  # Claude Code status line: `dir (git branch) | model | context % used`.
  # Claude Code pipes the session state as JSON on stdin.
  claudeStatusline = pkgs.writeShellApplication {
    name = "claude-statusline";
    runtimeInputs = [
      pkgs.jq
      pkgs.git
    ];
    text = ''
      input=$(cat)
      dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
      model=$(jq -r '.model.display_name // empty' <<<"$input")
      used=$(jq -r '.context_window.used_percentage // empty | round' <<<"$input")

      out=$'\e[34m'"''${dir/#$HOME/\~}"$'\e[0m'
      if branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null) && [ -n "$branch" ]; then
        out+=" "$'\e[35m'"($branch)"$'\e[0m'
      fi
      [ -n "$model" ] && out+=" | $model"
      [ -n "$used" ] && out+=" | $used% context"
      printf '%s' "$out"
    '';
  };
in
{
  programs = {
    opencode = {
      enable = true;
      mutableSettings = true;
      cli = {
        attention.notifications = true;
        session.thinking = "show";
      };
      settings = {
        update = "disable";
        plugins = [ "@mohak34/opencode-notifier" ];
      };
    };

    claude-code = {
      enable = true;
      plugins.caveman = caveman;
      # Claude Code writes settings.json itself (theme, /config), so merge the
      # declared settings into the writable file instead of a store symlink.
      mutableSettings = true;
      settings.statusLine = {
        type = "command";
        command = lib.getExe claudeStatusline;
      };
    };
  };
}
