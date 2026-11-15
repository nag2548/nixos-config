{ pkgs, lib, ... }:
let
  caveman = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "b4ee71d557d96e3cbc14f88fa6e953a1362865f5";
    hash = "sha256-HcNc+iyIL/K4JOBBsJAS2eh0vcpW3CwL5CQMqY0LMh0=";
  };

  mattpocockSkills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "5863806dd4e15c63174bee4e7515a4256792ecfa";
    hash = "sha256-AYSRCvBL8TDDdW3rgKu2T7gl4YYDoDId0jYbabEFyfs=";
  };

  # `grill-me` and `grill-with-docs` only call other skills, so those come along.
  grillSkills = {
    grill-me = "${mattpocockSkills}/skills/productivity/grill-me";
    grilling = "${mattpocockSkills}/skills/productivity/grilling";
    grill-with-docs = "${mattpocockSkills}/skills/engineering/grill-with-docs";
    domain-modeling = "${mattpocockSkills}/skills/engineering/domain-modeling";
  };

  # Caveman's opencode install, rebuilt from the pinned repo the way
  # `installer/install.js --only opencode` lays it out. Unlike the installer it
  # does not write caveman's Tier-3 ruleset into ~/.config/opencode/AGENTS.md:
  # that file is user-owned. The plugin still injects the active mode's ruleset
  # each turn.
  cavemanOpencode = pkgs.runCommand "caveman-opencode" { nativeBuildInputs = [ pkgs.nodejs ]; } ''
    plugin=$out/plugins/caveman
    mkdir -p $plugin $out/agents
    cp ${caveman}/src/plugins/opencode/{plugin.js,server.js,package.json} $plugin/
    cp ${caveman}/src/hooks/caveman-config.js $plugin/caveman-config.cjs
    cp ${caveman}/src/hooks/caveman-parse.js $plugin/caveman-parse.cjs
    # opencode rejects Claude-style `tools:` arrays and bare `model:` aliases.
    node -e '
      const fs = require("fs");
      const { transformOpencodeAgentFrontmatter: t } = require("${caveman}/installer/lib/opencode-agent");
      for (const n of fs.readdirSync("${caveman}/agents").filter((f) => /^cavecrew-.*\.md$/.test(f)))
        fs.writeFileSync(process.env.out + "/agents/" + n,
          t(fs.readFileSync("${caveman}/agents/" + n, "utf8"), { subagent: true }));
    '
  '';

  cavemanCommands = [
    "caveman"
    "ultracave"
    "megacave"
    "caveman-commit"
    "caveman-review"
    "caveman-compress"
    "caveman-stats"
    "caveman-help"
  ];

  cavemanAgents = [
    "cavecrew-investigator"
    "cavecrew-builder"
    "cavecrew-reviewer"
  ];

  # Claude Code status line:
  # `dir (git branch) | model | context % used (tokens used/window)`.
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
      tokens=$(jq -r '
        def k: if . >= 1000 then "\(. / 1000 | round)k" else "\(.)" end;
        (.context_window.current_usage // empty) as $u
        | (($u.input_tokens // 0) + ($u.cache_creation_input_tokens // 0)
           + ($u.cache_read_input_tokens // 0)) as $t
        | (.context_window.context_window_size // 0) as $w
        | if $w > 0 then "\($t | k)/\($w | k)" else empty end
      ' <<<"$input")

      out=$'\e[34m'"''${dir/#$HOME/\~}"$'\e[0m'
      if branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null) && [ -n "$branch" ]; then
        out+=" "$'\e[35m'"($branch)"$'\e[0m'
      fi
      [ -n "$model" ] && out+=" | $model"
      if [ -n "$used" ]; then
        out+=" | $used% context"
        [ -n "$tokens" ] && out+=" ($tokens)"
      fi
      printf '%s' "$out"
    '';
  };
in
{
  xdg.configFile."opencode/plugins/caveman" = {
    source = "${cavemanOpencode}/plugins/caveman";
    recursive = true;
  };

  programs = {
    opencode = {
      enable = true;
      mutableSettings = true;
      agents = lib.genAttrs cavemanAgents (name: "${cavemanOpencode}/agents/${name}.md");
      commands = lib.genAttrs cavemanCommands (
        name: "${caveman}/src/plugins/opencode/commands/${name}.md"
      );
      skills = grillSkills // {
        caveman = "${caveman}/skills/caveman";
        caveman-commit = "${caveman}/skills/caveman-commit";
        caveman-review = "${caveman}/skills/caveman-review";
        caveman-help = "${caveman}/skills/caveman-help";
        caveman-stats = "${caveman}/skills/caveman-stats";
        caveman-compress = "${caveman}/skills/caveman-compress";
        cavecrew = "${caveman}/skills/cavecrew";
        ultracave = "${caveman}/skills/ultracave";
        megacave = "${caveman}/skills/megacave";
      };
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
      skills = grillSkills;
      mutableSettings = true;
      settings = {
        statusLine = {
          type = "command";
          command = lib.getExe claudeStatusline;
        };
        hooks =
          let
            notify = msg: {
              hooks = [
                {
                  type = "command";
                  command = ''${lib.getExe' pkgs.libnotify "notify-send"} "Claude Code" "${msg}"'';
                }
              ];
            };
          in
          {
            Notification = [
              ((notify "Needs your input") // { matcher = "permission_prompt|elicitation_dialog"; })
            ];
            Stop = [ (notify "Session finished") ];
          };
      };
    };
  };
}
