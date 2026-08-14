# AGENTS.md

NixOS flake configuration (flakes + home-manager + sops-nix) for two machines.
Desktop is **niri** (Wayland tiling compositor) with the **Noctalia** shell on top
and the **Noctalia greeter** at the SDDM login. There is no CI, no test suite,
and no formatter config — `nixfmt` (in system packages) is the house formatter.

## Commands

- Rebuild a machine: `sudo nixos-rebuild switch --flake .#tenebrae` or `.#galanthus`
- Build without applying: `nixos-rebuild build --flake .#host`
- Validate everything: `nix flake check`
- Format changed files: `nixfmt <files>`
- Update inputs: `nix flake update` (or per-input: `nix flake update nixpkgs-stable`)

## Layout

- `flake.nix` — single source of truth for `username = "nadine"` and the
  `inputs` (`nixpkgs`, `nixpkgs-stable`, `home-manager`, `sops-nix`,
  `noctalia`, `noctalia-greeter`, `vicinae`, `catppuccin`), passed via
  `specialArgs` to both the system and home-manager configs. Always take
  `{ username, ... }` (and `inputs` when needed) as a module arg; never
  hardcode `nadine` in modules. A new host must also be registered in
  `nixosConfigurations` in `flake.nix`.
- `hosts/<host>/` — one dir per machine. `default.nix` imports the generated
  `hardware-configuration.nix` plus the shared `modules/*`. Hosts may also
  have a `modules/` subdir for host-specific config (e.g. galanthus's
  `services.nix` syncs the Windows bootloader onto the ESP).
- `modules/*` — NixOS system modules shared by every host (`common.nix`,
  `gaming.nix`, `users.nix`, `samba.nix`, `docker.nix`, `bluetooth.nix`).
  `modules/common.nix` is the place for desktop session / greeter / niri /
  noctalia system-level setup and the `pkgs.stable` overlay.
- `secrets/` — encrypted sops-nix secrets (`secrets.yaml`) keyed per host
  (see `.sops.yaml`).
- `home/` — shared home-manager config applied to user `nadine` on every host
  (`useGlobalPkgs`/`useUserPackages` true, so it builds against system nixpkgs
  and installs into the user profile). Top-level files group by domain:
  `browsers.nix`, `common.nix`, `git.nix`, `terminal.nix`, `thunderbird.nix`,
  `vicinae.nix`, `vscode.nix`. Desktop-specific stuff lives under
  `home/desktop/`.
- `home/desktop/` — niri, noctalia, catppuccin, gtk, xdg portals/mimeapps.
  `home/desktop/niri.nix` symlinks the validated `home/config/niri.kdl` into
  place (runs `niri validate` at build time).
- `home/config/` — raw config files for tools that don't have a nix option —
  `niri.kdl` is the only one right now.
- `home/themes/` — wallpapers referenced by noctalia and the noctalia greeter.

## Gotchas

- `hardware-configuration.nix` is machine-generated (`nixos-generate-config`) —
  edit the host's `default.nix` instead.
- Two nixpkgs inputs exist: unstable `nixpkgs` (the default `pkgs`) and stable
  `nixpkgs-stable` (26.05). The overlay in `modules/common.nix` exposes the
  stable set as `pkgs.stable`, so use `pkgs.stable.<package>` for stable pins
  instead of importing `inputs.nixpkgs-stable` directly.
- `modules/samba.nix` mounts `//192.168.100.31/documents` using sops-nix
  templates (`samba-truenas`) — credentials live in `secrets/secrets.yaml`,
  decrypted on demand into the nix store.
- The zsh `rebuild` alias points at `~/.schnee`, not this repo path — machines
  symlink the repo there. Don't "fix" the alias unless that changes.
- Both hosts share the same module set; the only host-specific differences are
  hostname, keyboard layout (tenebrae: `de`, galanthus: `us intl`) and
  galanthus's `solaar`/`hardware.logitech.wireless` plus its host-only
  `hosts/galanthus/modules/services.nix` (Windows bootloader sync).
- Noctalia reads `~/.config/noctalia/config.toml` (nix-managed) but overlays the
  user-editable `~/.local/state/noctalia/settings.toml` on top — so settings
  changed in the Noctalia UI silently win over nix. Change settings (especially
  the wallpaper) only in `programs.noctalia.settings`, never in the UI. The
  greeter reads its own config in `programs.noctalia-greeter.settings`.
  `~/.local/state/noctalia/settings.toml` is not in the repo and will keep stale
  overrides until cleared.
- `home/desktop/niri.nix` runs `niri validate` on the kdl at build time, so a
  syntax error in `home/config/niri.kdl` breaks the build. Fix the file,
  not the wrapper.

## Conventions

- Commit messages use gitmoji-style emoji prefixes (✨, 🔧, 🐛, ⬆️, …) with a
  short summary; `gitmoji-cli` is installed.
