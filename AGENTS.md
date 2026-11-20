# AGENTS.md

NixOS flake (flakes + home-manager + sops-nix) for three machines:

- **tenebrae**, **galanthus** — umbriel (Wayland compositor) + noctalia shell +
  noctalia-greeter. The niri session modules and home bundle stay around: switch
  back by changing the `session` argument in `flake.nix`
  (`mkHost "niri" ./hosts/tenebrae`).
- **caligo** — KDE Plasma 6 + SDDM `breeze`.

No CI, no tests. `nixfmt` is the house formatter.

## Commands

- Rebuild: `sudo nixos-rebuild switch --flake .#<host>` or `nh os switch` (zsh
  alias `rebuild`)
- Build only: `nixos-rebuild build --flake .#<host>`
- Validate: `nix flake check` (caligo fails until its
  `hardware-configuration.nix` placeholder is replaced)
- Update inputs: `nix flake update` (or `nix flake update <input>`)

## Layout

- `flake.nix` — owns `username = "nadine"` and all inputs, passed via
  `specialArgs`. `mkHost session hostPath` exposes `session`. New hosts must be
  added to `nixosConfigurations`. Modules take `{ username, session, ... }` (and
  `inputs` if needed); never hardcode `nadine` or assume a session.
- `hosts/<host>/` — `default.nix` imports the generated
  `hardware-configuration.nix` (never edit it), `modules/common.nix`, the
  matching `modules/<session>-session.nix` and the shared modules. Host-only
  config lives in `hosts/<host>/modules/`.
- `modules/` — NixOS modules. `common.nix` is shared by every host. Each
  `<session>-session.nix` gates its compositor on the `session` specialArg, so
  hosts can import several and only the matching one activates. The niri and
  umbriel modules both import `noctalia-greeter.nix`; KDE uses SDDM instead.
- `home/` — home-manager config for every host. `default.nix` imports the rest,
  including `./desktop` (shared) and `./desktop/${session}.nix` (per session).
  `home/desktop/noctalia.nix` is shared by the niri and umbriel bundles.
- `home/config/niri.kdl` — raw niri config; `home/desktop/umbriel.nix` is the
  umbriel config as an attrset.
- `secrets/secrets.yaml` — sops-nix secrets keyed per host (`.sops.yaml`). Add a
  new host's age key there before referencing host-specific secrets.
- `templates/latex/` — flake template (`nix flake init -t ~/.schnee#latex`).

## Gotchas

### General

- **Never search `/nix/store`** with `find`, `ls`, `grep`, `rg` or anything
  recursive. Use `nix path-info`, `nix eval`, or a known
  `/nix/store/<hash>-<name>` path.
- `programs.nh.flake` points at `$HOME/.schnee`, not this repo path (machines
  symlink the repo there). Don't "fix" it.
- Per-host differences beyond session: hostname, keyboard layout (tenebrae `de`,
  others `us intl`), tenebrae's wireguard secret, galanthus's
  `solaar`/`hardware.logitech.wireless` and Windows bootloader sync.
- `nixpkgs-stable` is currently unused. To pin a package from it, take `inputs`
  as a module arg and use
  `inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}`.
- Adding a session: `modules/<session>-session.nix`,
  `home/desktop/<session>.nix`, then `mkHost "<session>" ./hosts/<host>`. Name
  must match the home bundle file.
- `home/common.nix` patches `protonmail-bridge-gui` (QML env) and
  `citrix-workspace` (`GDK_BACKEND=x11`). Nixpkgs already pins `wfica` to X11;
  don't re-add it.

### Noctalia

- Noctalia overlays the UI-editable `~/.local/state/noctalia/settings.toml` on
  the nix-managed config, so UI changes silently win. Change settings (esp. the
  wallpaper) only in `programs.noctalia.settings`; the greeter uses
  `programs.noctalia-greeter.settings`. Stale overrides in that state file are
  not in the repo.

### Secret Service

A session needs its own provider (noctalia, nextcloud and protonmail-bridge use
it). Symptoms: `[secret-store] ... category=provider-unavailable` in umbriel
logs, `failed to open secretservice session: The name is not activatable` in
clients.

- niri's nixpkgs module enables gnome-keyring; umbriel replaces that module, so
  `modules/umbriel-session.nix` enables it explicitly.
- `services.gnome.gnome-keyring.enable` also adds `pam_gnome_keyring` to login
  (unlocks the keyring with the login password) and gnome-keyring must be in
  `xdg.portal.config.<session>.default` (Secret portal backend).
- caligo uses KWallet; do not enable gnome-keyring there.
- The `default` keyring collection alias must point at the keyring PAM unlocks
  (see noctalia's `docs/user/configuration/secret-service.mdx`).

### niri / umbriel

- `niri.kdl` is validated at build time (`niri validate`); fix the file, not the
  wrapper. The umbriel config is **not** validated at build time: use
  `umbriel config validate` with `XDG_CONFIG_HOME` pointing at a dir holding
  `umbriel/config.toml`. Unknown keybinds are dropped with a warning.
- Keep both files in sync where niri has an equivalent (outputs, layout, cursor,
  autostart, shared keybinds, floating rules). Scratchpads, submaps, pinned
  windows and blur are umbriel-only.
- Umbriel merges `[keybinds]` over a **compiled-in** default set, not the
  packaged `config.toml`. A user chord replaces only that chord's default.
- Umbriel 0.1.0 takes action args **space-separated**
  (`"Mod+Return" = "spawn kitty"`, `"Mod+1" = "workspace-switch 1"`); the colon
  form belongs to newer builds and is rejected.
- Wheel chords are `WheelUp/Down/Left/Right` (not niri's `WheelScroll*`).
- `window-modify-{width,height}-*` take a **fraction** (-0.9..0.9), not a
  percentage: niri `-10%` → `window-modify-width-left -0.1`.
- Umbriel sets `[input.keyboard]` to US (`us`/`intl`/`caps:escape`) on every
  host; otherwise it would use the X11 keymap from `services.xserver.xkb`.
- Umbriel starts Xwayland itself, so `programs.xwayland.enable` is required.
- The umbriel portal config lives in `modules/umbriel-session.nix`;
  `home/desktop/xdg.nix` only has a `niri` key.
- The `umbriel` flake input must **not** follow our nixpkgs: the cachix cache
  (`umbriel.cachix.org`, set in `modules/common.nix` and `flake.nix`'s
  `nixConfig`) only matches umbriel's own locked nixpkgs (`3ec636362e18`). If
  `follows` was ever set, removing it re-resolves to the newest unstable and
  every lookup misses. Recovery: delete the `umbriel/nixpkgs` entry from
  `flake.lock` and re-lock, or set `inputs.umbriel.inputs.nixpkgs.url` to the
  tarball the branch's lock names. The daemon reads substituters from
  `/etc/nix/nix.conf`, rewritten on the next switch.

### Packages and tools

- **`home/vicinae.nix` uses the vicinae flake's package**, not `pkgs.vicinae`
  (nixpkgs lags; the flake has the gcc15 fix for vicinae#2040). Don't pin
  `pkgs.vicinae`.
- `home/neovim.nix` (nvf): keep the hand-tuned `conform-nvim` timeouts and
  `require_cwd = false` for sqlfluff.
- **nvf's `jls` ships a stale maven hash** (maven 3.10.0 in nixpkgs changed the
  dependency tree). `home/neovim.nix` patches the hash into a copy of nvf's
  package file, builds its own `jls` and points the nvim-dap adapter at it;
  `presets.jls.enable = lib.mkForce false` is required. Update the two hashes
  when maven moves; the patch is a no-op once nvf fixes it upstream.
- **LaTeX:** `home/latex.nix` holds only the global baseline (`texliveMedium`,
  nvf `languages.tex`, VimTeX, cmp-vimtex, LuaSnip). Project packages
  (`biblatex`, `lipsum`, `biber`, …) go in the project flake
  (`templates/latex`), on top of `ps.scheme-medium` (`texlive.combine` is
  deprecated; `texliveSmall.withPackages` does not evaluate). Start nvim from
  the project dir so direnv's TeX Live is first on PATH.
  - VimTeX and cmp-vimtex are `startPlugins` (vimscript, no lazy-loading).
  - The LaTeX snippets are a lazy plugin (`lazy.plugins`, `ft = "tex"`, `before`
    hook loading LuaSnip), not a LuaSnip provider, with
    `pkg // { dependencies = [ ]; }` (not `overrideAttrs`, whose
    `nvimRequireCheck` fails without luasnip). Otherwise mnw warns
    `both startAttrs."luasnip" and optAttrs."luasnip" are defined`.
  - Keep `snippets.luasnip.providers = [ ]` and
    `snippets.luasnip.setupOpts.enable_autosnippets = true` (157 of 176 snippets
    are autosnippets).
- `modules/samba.nix` mounts `//192.168.100.31/documents` via sops-nix templates
  (`samba-truenas`).

## Conventions

Conventional Commits: `type(scope?): short summary` — lowercase, imperative, no
trailing period, under ~72 chars. Types: feat, fix, chore, docs, refactor,
build, ci, perf, style, test, revert. `!` after type/scope marks breaking
changes (explain in the body). Scope is a module or domain name (`niri`,
`umbriel`, `noctalia`, `sops`, `home`, a host name).
