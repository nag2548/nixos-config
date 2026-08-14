# AGENTS.md

NixOS flake configuration (flakes + home-manager) for two machines. There is no
CI, no test suite, and no formatter config — `nixfmt` (in system packages) is the
house formatter.

## Commands

- Rebuild a machine: `sudo nixos-rebuild switch --flake .#tenebrae` or `.#galanthus`
- Build without applying: `nixos-rebuild build --flake .#host`
- Validate everything: `nix flake check`
- Format changed files: `nixfmt <files>`
- Update inputs: `nix flake update` (or per-input: `nix flake update nixpkgs-unstable`)

## Layout

- `flake.nix` — single source of truth for `username = "nadine"` and the `inputs`,
  passed via `specialArgs` to both the system and home-manager configs. Always
  take `{ username, ... }` (and `inputs` when needed) as a module arg; never
  hardcode `nadine` in modules.
- `hosts/<host>/` — one dir per machine. `default.nix` imports the generated
  `hardware-configuration.nix` plus the shared `modules/*`. A new host must also
  be registered in `nixosConfigurations` in `flake.nix`.
- `modules/*` — NixOS system modules shared by every host (common, gaming, users,
  samba, docker, bluetooth).
- `home/*` — shared home-manager config applied to user `nadine` on every host
  (`useGlobalPkgs`/`useUserPackages` true, so it builds against system nixpkgs
  and installs into the user profile).

## Gotchas

- `hardware-configuration.nix` is machine-generated (`nixos-generate-config`) —
  edit the host's `default.nix` instead.
- Two nixpkgs inputs exist: stable `nixpkgs` (26.05) and `nixpkgs-unstable`. To
  use an unstable package follow the pattern in `home/common.nix`:
  `import inputs.nixpkgs-unstable { inherit (pkgs.stdenv.hostPlatform) system; }`.
- `modules/samba.nix` mounts `//192.168.100.31/documents` using per-machine
  credentials at `/etc/nixos/smb-secrets` (not in the repo).
- The zsh `rebuild` alias points at `~/.schnee`, not this repo path — machines
  symlink the repo there. Don't "fix" the alias unless that changes.
- Both hosts share the same module set; the only host-specific differences are
  hostname, keyboard layout (tenebrae: `de`, galanthus: `us intl`) and
  galanthus's `solaar`/`hardware.logitech.wireless`.
- Noctalia reads `~/.config/noctalia/config.toml` (nix-managed) but overlays the
  user-editable `~/.local/state/noctalia/settings.toml` on top — so settings
  changed in the Noctalia UI silently win over nix. Change settings (especially
  the wallpaper) only in `programs.noctalia.settings`, never in the UI. The
  greeter reads its own config in `programs.noctalia-greeter.settings`.
  `~/.local/state/noctalia/settings.toml` is not in the repo and will keep stale
  overrides until cleared.

## Conventions

- Commit messages use gitmoji-style emoji prefixes (✨, 🔧, 🐛, ⬆️, …) with a
  short summary; `gitmoji-cli` is installed.
