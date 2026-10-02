# AGENTS.md

NixOS flake configuration (flakes + home-manager + sops-nix) for three machines:

- **tenebrae** — niri (Wayland tiling) + noctalia shell + noctalia-greeter
- **galanthus** — niri (Wayland tiling) + noctalia shell + noctalia-greeter
- **caligo** — KDE Plasma 6 + breeze SDDM theme

There is no CI, no test suite, and no formatter config — `nixfmt` (in system
packages) is the house formatter.

## Commands

- Rebuild a machine: `sudo nixos-rebuild switch --flake .#tenebrae` (or
  `.#galanthus`, `.#caligo`)
- Build without applying: `nixos-rebuild build --flake .#host`
- Validate everything: `nix flake check` (caligo will fail until its
  `hardware-configuration.nix` placeholder is replaced — see Gotchas)
- Format changed files: `nixfmt <files>`
- Update inputs: `nix flake update` (or per-input:
  `nix flake update nixpkgs-stable`)

## Layout

- `flake.nix` — single source of truth for `username = "nadine"` and the
  `inputs` (`nixpkgs`, `nixpkgs-stable`, `home-manager`, `sops-nix`, `noctalia`,
  `noctalia-greeter`, `vicinae`, `vicinae-extensions`, `catppuccin`, `nvf`),
  passed via `specialArgs` to both the system and home-manager configs. The
  `mkHost` helper takes `(session, hostPath)` and exposes `session` as a
  `specialArg`; `session` selects which session module the home-manager side
  imports (see below). A new host must also be registered in
  `nixosConfigurations` in `flake.nix`. Always take `{ username, session, ... }`
  (and `inputs` when needed) as a module arg; never hardcode `nadine` or assume
  the session in modules.
- `hosts/<host>/` — one dir per machine. `default.nix` imports the generated
  `hardware-configuration.nix` plus `modules/common.nix` + exactly one of
  `modules/<session>-session.nix`. Hosts may also have a `modules/` subdir for
  host-specific config (e.g. galanthus's `services.nix` syncs the Windows
  bootloader onto the ESP).
- `modules/*` — NixOS system modules. `common.nix` is shared by every host
  (boot, nix settings, locale, pipewire, catppuccin, 1password, etc.). Per-
  session config lives in `modules/<session>-session.nix`:
  - `niri-session.nix` — `programs.niri.enable` + `programs.noctalia-greeter`
  - `kde-session.nix` — `services.desktopManager.plasma6.enable` + SDDM with the
    `breeze` theme
  - The other shared modules (`gaming.nix`, `users.nix`, `samba.nix`,
    `docker.nix`, `bluetooth.nix`, `syncthing.nix`) are session-agnostic.
- `secrets/` — encrypted sops-nix secrets (`secrets.yaml`) keyed per host (see
  `.sops.yaml`). Add a new host's age public key to `.sops.yaml` and to the
  `creation_rules` key group before referencing host-specific secrets.
- `home/` — shared home-manager config applied to user `nadine` on every host
  (`useGlobalPkgs`/`useUserPackages` true, so it builds against system nixpkgs
  and installs into the user profile). `default.nix` is the importer and also
  sets the sops default file, age key path and `home.stateVersion`; it imports
  `./desktop` (shared) plus `./desktop/${session}.nix` (per session bundle).
  Top-level files group by domain: `browsers.nix`, `common.nix`, `fonts.nix`,
  `git.nix`, `neovim.nix`, `terminal.nix`, `thunderbird.nix`, `vicinae.nix`,
  `vscode.nix`. Desktop-specific stuff lives under `home/desktop/`.
- `home/desktop/` — `default.nix` imports the shared `catppuccin.nix`,
  `gtk.nix`, `xdg.nix` and adds the cross-DE packages (`nautilus`,
  `xdg-user-dirs-gtk`). Session-specific bundles:
  - `niri.nix` — symlinks the validated `home/config/niri.kdl` into place (runs
    `niri validate` at build time), enables polkit-gnome, imports
    `noctalia.nix`, and adds `swaybg` + `xwayland-satellite`
  - `kde.nix` — adds `dolphin`, `konsole`, `spectacle` (plasma6 ships everything
    else via the system module)
- `home/config/` — raw config files for tools that don't have a nix option —
  `niri.kdl` is the only one right now.
- `home/themes/` — wallpapers referenced by noctalia and the noctalia greeter.

## Gotchas

- `hardware-configuration.nix` is machine-generated (`nixos-generate-config`) —
  edit the host's `default.nix` instead. The `caligo` placeholder is an
  asserting module that fails loudly until replaced with a real one.
- Two nixpkgs inputs exist: unstable `nixpkgs` (the default `pkgs`) and stable
  `nixpkgs-stable` (26.05). The overlay in `modules/common.nix` exposes the
  stable set as `pkgs.stable`, so use `pkgs.stable.<package>` for stable pins
  instead of importing `inputs.nixpkgs-stable` directly.
- `modules/samba.nix` mounts `//192.168.100.31/documents` using sops-nix
  templates (`samba-truenas`) — credentials live in `secrets/secrets.yaml`,
  decrypted on demand into the nix store.
- The zsh `rebuild` alias points at `~/.schnee`, not this repo path — machines
  symlink the repo there. Don't "fix" the alias unless that changes.
- Per-host differences beyond session are: hostname, keyboard layout (tenebrae:
  `de`, galanthus & caligo: `us intl`), and galanthus's
  `solaar`/`hardware.logitech.wireless` plus its host-only
  `hosts/galanthus/modules/services.nix` (Windows bootloader sync).
- Noctalia reads `~/.config/noctalia/config.toml` (nix-managed) but overlays the
  user-editable `~/.local/state/noctalia/settings.toml` on top — so settings
  changed in the Noctalia UI silently win over nix. Change settings (especially
  the wallpaper) only in `programs.noctalia.settings`, never in the UI. The
  greeter reads its own config in `programs.noctalia-greeter.settings`.
  `~/.local/state/noctalia/settings.toml` is not in the repo and will keep stale
  overrides until cleared.
- `home/desktop/niri.nix` runs `niri validate` on the kdl at build time, so a
  syntax error in `home/config/niri.kdl` breaks the build. Fix the file, not the
  wrapper.
- Adding a new session means: (1) `modules/<session>-session.nix` for system
  config, (2) `home/desktop/<session>.nix` for the home bundle, (3) wire it via
  `mkHost "<session>" ./hosts/<host>` in `flake.nix`. Pick a session name that
  matches the home bundle filename.
- `noctalia-greeter.nixosModules.default` and `noctalia.homeModules.default` are
  loaded for every host. They're no-ops unless the matching
  `programs.noctalia-greeter.enable` / `programs.noctalia.enable` is set, so
  non-niri hosts are unaffected.

## Conventions

- Commit messages follow
  [Conventional Commits](https://www.conventionalcommits.org/):
  `type(scope?): short summary` — lowercase summary, no trailing period,
  imperative mood ("add" not "added"), under ~72 chars. Common types:
  - **feat** — new user-facing feature
  - **fix** — bug fix
  - **chore** — maintenance that doesn't affect production code (deps, tooling,
    formatting, refactors with no behavior change)
  - **docs** — docs only
  - **refactor** — code change that neither fixes a bug nor adds a feature
  - **build**, **ci**, **perf**, **style**, **test**, **revert** — used as
    needed
  - Use a `!` after the type/scope for breaking changes:
    `feat(niri)!: swap keybind
    for ...`, and explain the breakage in the
    body.
  - Scope is optional; when used, prefer a module or domain name (`niri`,
    `noctalia`, `sops`, `home`, `galanthus`, etc.).
