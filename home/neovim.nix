{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

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
            kdlfmt = {
              command = "${pkgs.kdlfmt}/bin/kdlfmt";
            };
            nixfmt = {
              command = "${pkgs.nixfmt}/bin/nixfmt";
            };
            prettier = {
              command = lib.mkForce "${pkgs.prettier}/bin/prettier";
            };
            google-java-format = {
              command = "${pkgs.google-java-format}/bin/google-java-format";
              args = [
                "--assume-filename"
                "$FILENAME"
                "-"
              ];
            };
            sqlfluff = {
              command = lib.mkForce "${pkgs.sqlfluff}/bin/sqlfluff";
              args = [
                "fix"
                "--dialect"
                "ansi"
                "-"
              ];
              # sqlfluff exits 1 when it fixed something, which conform would
              # otherwise treat as a failure
              exit_codes = [
                0
                1
              ];
              # conform's builtin sqlfluff config requires a project root
              # marker (.sqlfluff, pyproject.toml, ...); run in the buffer's
              # directory instead so plain SQL files work
              require_cwd = false;
            };
          };
          formatters_by_ft = lib.mkAfter {
            kdl = [ "kdlfmt" ];
            nix = [ "nixfmt" ];
            java = [ "google-java-format" ];
          };
          # google-java-format is a JVM launcher and needs well over nvf's
          # 500ms default to start, so raise the format-on-save timeout.
          format_on_save = lib.mkAfter (
            lib.generators.mkLuaInline ''
              function()
                if vim.b.nvf_format_save == nil and not vim.g.nvf_format_save then
                  return
                elseif vim.b.nvf_format_save then
                  return
                else
                  return {lsp_format = "fallback", timeout_ms = 5000}
                end
              end
            ''
          );
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
        grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
          kdl
        ];
      };

      visuals.indent-blankline.enable = true;
      mini.tabline.enable = true;
      filetree.neo-tree.enable = true;
      statusline.lualine.enable = true;
      fzf-lua.enable = true;
      autopairs.nvim-autopairs.enable = true;
      autocomplete.nvim-cmp.enable = true;
      visuals.nvim-web-devicons.enable = true;

      diagnostics = {
        enable = true;
        config = {
          virtual_text = true;
        };
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        enableDAP = true;

        css.enable = true;
        docker.enable = true;
        html.enable = true;
        java = {
          enable = true;
          format.type = [ ];
          extensions = {
            maven-nvim.enable = true;
          };
        };
        markdown = {
          enable = true;
          extensions = {
            render-markdown-nvim.enable = true;
          };
        };
        nix = {
          enable = true;
          lsp.servers = [ "nixd" ];
          format.type = [ "nixfmt" ];
        };
        rust.enable = true;
        sql.enable = true;
        svelte.enable = true;
        typescript.enable = true;
        xml.enable = true;
        yaml.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
      };
    };
  };
}
