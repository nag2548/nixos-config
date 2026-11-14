# LaTeX baseline: a global TeX Live plus the neovim (nvf) setup around
# VimTeX, texlab, tex-fmt and LaTeX snippets. Project-specific TeX packages
# belong in the project's own flake (see templates/latex); its devShell puts
# its own TeX Live first on PATH through direnv.
{ pkgs, ... }:
{
  # scheme-medium is the smallest scheme that ships latexmk, which VimTeX
  # drives. Enough for one-off documents outside a project shell.
  home.packages = [ pkgs.texliveMedium ];

  programs.nvf.settings.vim = {
    # VimTeX and cmp-vimtex are vimscript plugins and cannot be lazy-loaded
    # through lua, so they go into startPlugins.
    startPlugins = [
      pkgs.vimPlugins.vimtex
      pkgs.vimPlugins.cmp-vimtex
    ];

    globals = {
      vimtex_compiler_method = "latexmk";
      vimtex_python_method = "python3";
      vimtex_view_method = "zathura";
      vimtex_view_zathura_check_libsynctex = 0;
    };

    # nvf loads LuaSnip lazily (opt). The LaTeX snippets declare `luasnip`
    # as a dependency, which mnw would put into start as well (it warns
    # about luasnip in both). Load the snippets lazily on tex buffers,
    # after LuaSnip, without that dependency.
    snippets.luasnip = {
      enable = true;
      providers = [ ];
      # Most LaTeX snippets (math, environments) are autosnippets.
      setupOpts.enable_autosnippets = true;
    };
    lazy.plugins."luasnip-latex-snippets.nvim" = {
      # mnw installs a plugin's declared dependencies into start even for
      # lazy plugins; `before` loads LuaSnip itself, so drop the dependency.
      # Plain attr update, not overrideAttrs: overrideAttrs rebuilds the
      # plugin and its nvimRequireCheck fails without luasnip.
      package = pkgs.vimPlugins.luasnip-latex-snippets-nvim // {
        dependencies = [ ];
      };
      ft = "tex";
      before = ''require("lz.n").trigger_load("luasnip")'';
    };

    autocomplete.nvim-cmp.sources.vimtex = "[VimTeX]";

    # treesitter latex/bibtex grammars, texlab LSP and tex-fmt formatting.
    languages.tex.enable = true;
  };
}
