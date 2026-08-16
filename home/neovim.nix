{ pkgs, ... }:

{
  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;
      searchCase = "smart";

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      options = {
        autoindent = true;
        cursorline = true;
        cursorlineopt = "both";
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        termguicolors = true;
        expandtab = true;
        smartindent = true;
        hlsearch = true;
        incsearch = true;
        number = true;
        relativenumber = false;
      };

      keymaps = [
        {
          # copy to system clipboard
          key = "<leader>y";
          mode = [
            "n"
            "v"
          ];
          action = ''"+y'';
        }
      ];

      autopairs.nvim-autopairs.enable = true;

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters.nixfmt = {
            command = "${pkgs.nixfmt}/bin/nixfmt";
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
          };
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      spellcheck.languages = [
        "en"
        "de"
      ];

      treesitter.context.enable = true;
      visuals.indent-blankline.enable = true;

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        markdown.enable = true;
        nix = {
          enable = true;
          lsp.servers = [ "nixd" ];
          format.type = [ "nixfmt" ];
        };
      };
    };
  };
}
