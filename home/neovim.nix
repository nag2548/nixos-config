{ pkgs, ... }:
{
  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = true;

    settings.vim = {
      startPlugins = [ pkgs.vimPlugins.vim-tmux-navigator ];
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
        scrolloff = 999;
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
          key = "<A-Up>";
          mode = "n";
          action = ":m .-2<CR>==";
          desc = "Move line up";
        }
        {
          key = "<A-Down>";
          mode = "n";
          action = ":m .+1<CR>==";
          desc = "Move line down";
        }
        {
          key = "<A-Up>";
          mode = "v";
          action = ":m '<-2<CR>gv=gv";
          desc = "Move selection up";
        }
        {
          key = "<A-Down>";
          mode = "v";
          action = ":m '>+1<CR>gv=gv";
          desc = "Move selection down";
        }
        {
          key = "<C-h>";
          mode = "n";
          silent = true;
          action = ":TmuxNavigateLeft<CR>";
        }
        {
          key = "<C-j>";
          mode = "n";
          silent = true;
          action = ":TmuxNavigateDown<CR>";
        }
        {
          key = "<C-k>";
          mode = "n";
          silent = true;
          action = ":TmuxNavigateUp<CR>";
        }
        {
          key = "<C-l>";
          mode = "n";
          silent = true;
          action = ":TmuxNavigateRight<CR>";
        }
        {
          key = "<leader>ff";
          desc = "Find files";
          mode = "n";
          silent = true;
          lua = true;
          action = "function() require('fzf-lua').files() end";
        }
        {
          key = "<leader>fg";
          desc = "Live grep";
          mode = "n";
          silent = true;
          lua = true;
          action = "function() require('fzf-lua').live_grep() end";
        }
        {
          key = "<leader>fb";
          desc = "Buffers";
          mode = "n";
          silent = true;
          lua = true;
          action = "function() require('fzf-lua').buffers() end";
        }
      ];

      binds = {
        cheatsheet.enable = true;
        whichKey.enable = true;
      };

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters = {
            nixfmt = {
              command = "${pkgs.nixfmt}/bin/nixfmt";
            };
            kdlfmt = {
              command = "${pkgs.kdlfmt}/bin/kdlfmt";
            };
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            kdl = [ "kdlfmt" ];
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

      treesitter = {
        context.enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [ kdl ];
      };

      visuals.indent-blankline.enable = true;
      mini.tabline.enable = true;
      filetree.neo-tree.enable = true;
      statusline.lualine.enable = true;
      fzf-lua.enable = true;
      autopairs.nvim-autopairs.enable = true;
      autocomplete.nvim-cmp.enable = true;
      visuals.nvim-web-devicons.enable = true;

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

      git = {
        enable = true;
        gitsigns.enable = true;
      };
    };
  };
}
