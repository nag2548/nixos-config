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
        {
          key = "<leader>ca";
          mode = "n";
          silent = true;
          lua = true;
          action = "vim.lsp.buf.code_action";
        }
        {
          key = "<leader>t";
          mode = "n";
          silent = true;
          action = ":Neotree toggle<CR>";
        }
        {
          # no macro menu
          key = "q";
          mode = "n";
          silent = true;
          action = "<nop>";
        }
        {
          key = "<C-h>";
          mode = "n";
          silent = true;
          action = "<C-w>h";
        }
        {
          key = "<C-j>";
          mode = "n";
          silent = true;
          action = "<C-w>j";
        }
        {
          key = "<C-k>";
          mode = "n";
          silent = true;
          action = "<C-w>k";
        }
        {
          key = "<C-l>";
          mode = "n";
          silent = true;
          action = "<C-w>l";
        }
      ];

      binds = {
        cheatsheet.enable = true;
        whichKey.enable = true;
      };

      autopairs.nvim-autopairs.enable = true;

      autocomplete.blink-cmp = {
        enable = true;
        setupOpts = {
          signature.enabled = true;
        };
      };

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

        css.enable = true;
        docker.enable = true;
        html.enable = true;
        markdown.enable = true;
        nix = {
          enable = true;
          lsp.servers = [ "nixd" ];
          format.type = [ "nixfmt" ];
        };
        sql.enable = true;
        typescript.enable = true;
      };

      filetree.neo-tree.enable = true;

      statusline.lualine = {
        enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
      };
    };
  };
}
