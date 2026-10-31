# AGENTS.md

NixOS flake configuration (flakes + home-manager + sops-nix) for three machines:

- **tenebrae** — umbriel (Wayland compositor) + noctalia shell + noctalia-greeter
- **galanthus** — umbriel (Wayland compositor) + noctalia shell + noctalia-greeter
- **caligo** — KDE Plasma 6 + breeze SDDM theme

tenebrae and galanthus keep their niri session modules and home bundle around:
switching back is a one-word change of the `session` argument in `flake.nix`
(`mkHost "niri" ./hosts/tenebrae`).

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
  `noctalia-greeter`, `umbriel`, `vicinae`, `vicinae-extensions`, `catppuccin`,
  `nvf`), passed via `specialArgs` to both the system and home-manager configs.
  The `mkHost` helper takes `(session, hostPath)` and exposes `session` as a
  `specialArg`; `session` selects which session module the home-manager side
  imports (see below). A new host must also be registered in
  `nixosConfigurations` in `flake.nix`. Always take `{ username, session, ... }`
  (and `inputs` when needed) as a module arg; never hardcode `nadine` or assume
  the session in modules.
  The `umbriel` input tracks the `cachix` branch and keeps its own nixpkgs —
  see the Gotchas section before touching it.
- `hosts/<host>/` — one dir per machine. `default.nix` imports the generated
  `hardware-configuration.nix`, `modules/common.nix`, the matching
  `modules/<session>-session.nix`, and every shared session-agnostic module
  (`gaming`, `users`, `samba`, `docker`, `bluetooth`, `syncthing`). Hosts may
  also have a `modules/` subdir for host-specific config on top of that (e.g.
  galanthus's `services.nix` syncs the Windows bootloader onto the ESP).
- `modules/*` — NixOS system modules. `common.nix` is shared by every host
  (boot, nix settings, locale, pipewire, catppuccin, 1password, etc.). Per-
  session config lives in `modules/<session>-session.nix`. Each session module
  gates its compositor on the `session` specialArg, so a host can import
  several of them and only the matching one activates:
  - `niri-session.nix` — `programs.niri.enable` when `session == "niri"`
  - `umbriel-session.nix` — imports `inputs.umbriel.nixosModules.default` and
    sets `programs.umbriel.enable` when `session == "umbriel"`, plus
    `programs.xwayland.enable` (umbriel starts the wlroots Xwayland server
    itself and finds `Xwayland` on PATH)
  - `kde-session.nix` — `services.desktopManager.plasma6.enable` + SDDM with the
    `breeze` theme
  - `noctalia-greeter.nix` — the greeter (palette, wallpaper, cursor), shared
    by the niri and umbriel sessions
  - The other shared modules (`gaming.nix`, `hardware.nix`, `plymouth.nix`,
    `users.nix`, `samba.nix`, `docker.nix`, `bluetooth.nix`, `syncthing.nix`)
    are session-agnostic.
- `secrets/` — encrypted sops-nix secrets (`secrets.yaml`) keyed per host (see
  `.sops.yaml`). Add a new host's age public key to `.sops.yaml` and to the
  `creation_rules` key group before referencing host-specific secrets.
- `home/` — shared home-manager config applied to user `nadine` on every host
  (`useGlobalPkgs`/`useUserPackages` true, so it builds against system nixpkgs
  and installs into the user profile). `default.nix` is the importer and also
  sets the sops default file, age key path and `home.stateVersion`; it imports
  `./browsers` (shared), `./desktop` (shared cross-DE defaults) and
  `./desktop/${session}.nix` (per session bundle). Top-level files group by
  domain: `default.nix` (importer), `browsers/` (with a `firefox/` subdir),
  `common.nix`, `fonts.nix`, `git.nix`, `neovim.nix`, `terminal.nix`,
  `thunderbird.nix`, `vicinae.nix`, `vscode.nix`. Desktop-specific stuff
  lives under `home/desktop/`.
- `home/desktop/` — `default.nix` imports the shared `catppuccin.nix`,
  `gtk.nix`, `xdg.nix` and adds the cross-DE packages (`nautilus`,
  `xdg-user-dirs-gtk`). Session-specific bundles:
  - `niri.nix` — symlinks the validated `home/config/niri.kdl` into place (runs
    `niri validate` at build time), enables polkit-gnome, imports
    `noctalia.nix` and `screenshot.nix`, and adds `nirius` (launcher) and
    `xwayland-satellite` (Xwayland-on-demand)
  - `umbriel.nix` — imports `inputs.umbriel.homeModules.default` and writes the
    compositor config as a Nix attrset under `programs.umbriel.settings`
    (serialized to TOML by the module). The `[keybinds]` table only lists the
    binds niri had and umbriel's own defaults do not cover — umbriel keeps its
    compiled-in set for the rest. Also enables polkit-gnome, imports
    `noctalia.nix` and `screenshot.nix`, and turns on Noctalia's umbriel
    overview toggles
  - `screenshot.nix` — shared `nshot` wrapper (grim/slurp/swappy) plus
    `swaybg` wallpaper fallback; the window-capture command depends on the
    session (`niri msg action screenshot-window` vs `noctalia msg
    screenshot-window`)
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
  `nixpkgs-stable` (26.05). The stable input is currently declared but unused
  — nothing exposes `pkgs.stable`, so reach for `inputs.nixpkgs-stable` only
  if you also add an overlay (e.g. in `modules/common.nix`) that wires it in.
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
- The umbriel config is a Nix attrset in `home/desktop/umbriel.nix`, rendered to
  TOML by `inputs.umbriel.homeModules.default`. It is *not* validated at build
  time; umbriel only reports config errors at runtime. Check it with
  `umbriel config validate` (point `XDG_CONFIG_HOME` at a dir holding
  `umbriel/config.toml`). An unknown keybind is dropped with a warning.
- Umbriel merges the user's `[keybinds]` table over a **compiled-in** default
  set (`defaultKeybinds()` in `src/config/keybind_parse.cpp`), not over the
  packaged `share/umbriel/config.toml`. A user chord replaces the default for
  that chord; other defaults stay. The packaged file is only a starting
  example — it is used when no user config exists.
- Umbriel 0.1.0 takes action arguments **space-separated**, not colon-separated:
  `"Mod+Return" = "spawn kitty"`, `"Mod+1" = "workspace-switch 1"`. The colon
  form (`spawn:kitty`) belongs to the newer `0-unstable-*` nixpkgs build and is
  rejected as an unknown action by 0.1.0.
- Umbriel wheel chords are `WheelUp`/`WheelDown`/`WheelLeft`/`WheelRight`, not
  niri's `WheelScrollUp`/`WheelScrollDown`. Niri's `WheelScroll*` chords are
  dropped as "bad chord" by umbriel.
- `window-modify-width-*` and `window-modify-height-*` take a **fraction**
  delta (-0.9 to 0.9), not a percentage. Niri's `Mod+Minus` was -10%, so it
  maps to `window-modify-width-left -0.1`.
- The `umbriel` flake input must **not** follow our nixpkgs — the binary cache
  (`umbriel.cachix.org`) only matches the umbriel flake's own locked nixpkgs.
  The `cachix` branch ships that lock (`3ec636362e18`), and a fresh
  `nix flake lock` picks it up on its own.
  Gotcha: if `follows` was ever set on that input, the branch's revision is
  dropped from `flake.lock`, and removing `follows` afterwards makes nix
  re-resolve the channel URL to the *newest* unstable — every cache lookup
  then misses. Recovery: delete the `umbriel/nixpkgs` entry from `flake.lock`
  and re-lock, or set `inputs.umbriel.inputs.nixpkgs.url` to the exact
  tarball the branch's lock names.
- `umbriel.cachix.org` is registered in `modules/common.nix` and in the
  `nixConfig` block of `flake.nix`. The daemon reads substituters from
  `/etc/nix/nix.conf`, which is rewritten on the next `nixos-rebuild switch`.
- Switching the compositor on tenebrae/galanthus means changing the `session`
  string in `flake.nix` only; both session modules and both home bundles are
  already imported by the hosts. Keep the niri files around so the switch is
  reversible.
- Umbriel reads the keyboard layout from `[input.keyboard]`, which the umbriel
  config sets to the English (US) layout (`us`/`intl`/`caps:escape`) on every
  host. Without that setting it would fall back to the systemd-localed X11
  keymap, which NixOS fills from `services.xserver.xkb` (German on tenebrae,
  US intl on galanthus and caligo).
- Adding a new session means: (1) `modules/<session>-session.nix` for system
  config, (2) `home/desktop/<session>.nix` for the home bundle, (3) wire it via
  `mkHost "<session>" ./hosts/<host>` in `flake.nix`. Pick a session name that
  matches the home bundle filename.
- `noctalia-greeter.nixosModules.default` and `noctalia.homeModules.default` are
  loaded for every host. They're no-ops unless the matching
  `programs.noctalia-greeter.enable` / `programs.noctalia.enable` is set, so
  non-niri hosts are unaffected.
- **A session needs its own Secret Service provider.** Noctalia stores its
  storage master key and calendar credentials through the Secret Service, and
  apps like nextcloud and the protonmail bridge use it too. `libsecret` is
  only the client library — a provider has to run in the login session.
  - The nixpkgs niri module sets `services.gnome.gnome-keyring.enable =
    lib.mkDefault true`. Umbriel replaces that module (`disabledModules` in
    umbriel's own nixos module), so nothing enables the keyring there —
    `modules/umbriel-session.nix` has to do it explicitly.
  - `services.gnome.gnome-keyring.enable` also sets
    `security.pam.services.login.enableGnomeKeyring`, which adds
    `pam_gnome_keyring` to the login stack. That unlocks the "Login" keyring
    with the login password; without it every login re-prompts for keyring
    passwords.
  - gnome-keyring also ships the `org.freedesktop.impl.portal.Secret`
    backend, so it must be in `xdg.portal.config.<session>.default`
    alongside the other portals.
  - caligo (KDE) uses KWallet instead — do not enable gnome-keyring there.
  - Symptom to recognize: `umbriel` logs
    `[secret-store] operation=lookup scope=storage status=unavailable
    category=provider-unavailable`, and clients log
    `failed to open secretservice session: The name is not activatable`.
  - Noctalia's docs (`docs/user/configuration/secret-service.mdx`) also cover
    the separate "multiple keyrings" trap: the `default` collection alias must
    point at the keyring PAM unlocks.
- **Never search `/nix/store`** with `find`, `ls`, `grep`, `rg`, or anything
  recursive. The store has tens of thousands of paths and scans take forever.
  Use `nix path-info`, `nix eval`, or open the specific source file directly. If
  you must look in the store, target a known path (`/nix/store/<hash>-<name>`) —
  never `find /nix/store` or `rg /nix/store`.

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
