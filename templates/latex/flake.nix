{
  description = "LaTeX project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # Project TeX Live: scheme-medium (ships latexmk) plus whatever this
      # project needs on top. Find package names with
      # `nix search nixpkgs#texlive <name>` or on https://ctan.org.
      texFor =
        pkgs:
        pkgs.texlive.withPackages (
          ps: with ps; [
            scheme-medium
            # biblatex
            # biber
            # csquotes
          ]
        );
    in
    {
      # `direnv allow` (via .envrc) or `nix develop` puts this TeX Live first
      # on PATH, so VimTeX, latexmk and texlab use it.
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [ (texFor pkgs) ];
        };
      });

      # `nix build` compiles main.tex into result/main.pdf.
      packages = forAllSystems (pkgs: {
        default = pkgs.stdenvNoCC.mkDerivation {
          name = "latex-document";
          src = self;
          nativeBuildInputs = [ (texFor pkgs) ];
          buildPhase = ''
            runHook preBuild
            export HOME=$TMPDIR
            export TEXMFHOME=$TMPDIR/texmf TEXMFVAR=$TMPDIR/texmf-var
            # Reproducible timestamps in the PDF.
            export SOURCE_DATE_EPOCH=${toString (self.lastModified or 0)}
            latexmk main.tex
            runHook postBuild
          '';
          installPhase = ''
            runHook preInstall
            install -Dm644 build/main.pdf $out/main.pdf
            runHook postInstall
          '';
        };
      });
    };
}
