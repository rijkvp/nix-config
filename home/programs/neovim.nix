{ config, pkgs, lib, theme, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 6

      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true

      vim.opt.smartindent = true

      vim.opt.wrap = false
      vim.opt.linebreak = true

      vim.opt.spelllang = { 'en', 'nl' }

      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.undofile = true

      vim.opt.hlsearch = true
      vim.opt.incsearch = true

      vim.opt.termguicolors = true
      vim.opt.showmode = false

      vim.opt.updatetime = 50

      -- Remaps
      vim.g.mapleader = " "

      vim.keymap.set('n', 'j', 'gj')
      vim.keymap.set('n', 'k', 'gk')
      vim.keymap.set('n', '<leader>w', ':set wrap!<CR>')
      vim.keymap.set('n', '<leader>s', ':set spell!<CR>')
    '';
    plugins = with pkgs.vimPlugins; [
      # Theme
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = ''
          require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
          })
        '';
      }
      {
        plugin = tokyonight-nvim;
        type = "lua";
        config = ''
          require("tokyonight").setup({
            style = "moon",
            transparent = true,
          })
          vim.cmd[[colorscheme ${theme.id}]]
        '';
      }

      plenary-nvim
      # Telescope
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>p', builtin.find_files, {})
          vim.keymap.set('n', '<C-p>', builtin.git_files, {})
          vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>b', builtin.buffers, {})
          vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
          vim.keymap.set('n', '<leader>sd', builtin.diagnostics, {})
          vim.keymap.set('n', '<leader>ss', builtin.spell_suggest, {})
          require('telescope').setup{
           defaults = {
             sorting_strategy = "ascending",
             layout_strategy = "horizontal",
             layout_config = {
               horizontal = {
                 prompt_position = "top",
                 preview_width = 0.5,
               },
             },
           },
          }
        '';
      }
      {
        plugin = telescope-file-browser-nvim;
        type = "lua";
        config = ''
          vim.api.nvim_set_keymap("n", "<C-f>", ":Telescope file_browser<CR>", { noremap = true })
        '';
      }

      # Status line
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup()
        '';
      }

      # Tree sitter
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            -- From kickstart.nvim
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<M-space>',
              },
            },
            textobjects = {
              select = {
                enable = true,
                lookahead = true,
                keymaps = {
                  ['aa'] = '@parameter.outer',
                  ['ia'] = '@parameter.inner',
                  ['af'] = '@function.outer',
                  ['if'] = '@function.inner',
                  ['ac'] = '@class.outer',
                  ['ic'] = '@class.inner',
                },
              },
              move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                  [']m'] = '@function.outer',
                  [']]'] = '@class.outer',
                },
                goto_next_end = {
                  [']M'] = '@function.outer',
                  [']['] = '@class.outer',
                },
                goto_previous_start = {
                  ['[m'] = '@function.outer',
                  ['[['] = '@class.outer',
                },
                goto_previous_end = {
                  ['[M'] = '@function.outer',
                  ['[]'] = '@class.outer',
                },
              },
              swap = {
                enable = true,
                swap_next = {
                  ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                  ['<leader>A'] = '@parameter.inner',
                },
              },
            }
          }
        '';
      }

      # Syntaxes
      {
        plugin = vim-markdown;
        config = ''
          let g:vim_markdown_folding_disabled = 1
        '';
      }
      vim-nix
      vim-toml

      # LSP
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          vim.lsp.set_log_level("debug")

          local lspconfig = require('lspconfig')

          -- Language servers
          -- lspconfig.rust_analyzer.setup{} -- handled by rust-tools.nvim
          lspconfig.tsserver.setup{}
          lspconfig.clangd.setup{}
          lspconfig.rnix.setup{}
          lspconfig.texlab.setup{}
          lspconfig.ruff_lsp.setup{}
          lspconfig.hls.setup{}

          -- Documentation
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })

          -- Goto
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
          vim.keymap.set("n", "gi", require('telescope.builtin').lsp_implementations, { desc = "Go to implementation" })
          vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
          vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references, { desc = "Go to references" })

          -- Diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostics" })

          -- Actions
          vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action,  { desc = "LSP Action" })
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, { desc = "Format code"})
          vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
        '';
      }
      nvim-web-devicons
      trouble-nvim
      {
        plugin = rust-tools-nvim;
        type = "lua";
        config = ''
          require('rust-tools').setup()
        '';
      }

      {
        plugin = alpha-nvim;
        type = "lua";
        config = ''
          require'alpha'.setup(require'alpha.themes.startify'.config)
        '';
      }

      # Completion plugins
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-spell
      lspkind-nvim # for icons in completion
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require('cmp')
          cmp.setup{
            formatting = { format = require('lspkind').cmp_format() },
            mapping = {
              ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
              ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
              ['<C-y>'] = cmp.mapping.confirm(),
              ['<C-d>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
            },
            sources = {
              { name='nvim_lsp' },
              { name='buffer', option = { get_bufnrs = vim.api.nvim_list_bufs } },
              { name='path' },
              { name='spell' },
            },
          }
        '';
      }

      # Other
      {
        plugin = harpoon;
        type = "lua";
        config = ''
          local mark = require('harpoon.mark')
          local ui = require('harpoon.ui')

          vim.keymap.set('n', '<leader>a', mark.add_file)
          vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

          vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end)
          vim.keymap.set('n', '<C-t>', function() ui.nav_file(2) end)
          vim.keymap.set('n', '<C-n>', function() ui.nav_file(3) end)
          vim.keymap.set('n', '<C-s>', function() ui.nav_file(4) end)
        '';
      }
      {
        plugin = undotree;
        type = "lua";
        config = ''
          vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
        '';
      }
      {
        plugin = copilot-vim;
        config = ''
          let g:copilot_filetypes = {
           \ 'text': v:false,
           \ 'xml': v:false,
           \ 'todo': v:false,
           \}
        '';
      }

      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = ''
          require('colorizer').setup()
        '';
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require('nvim-autopairs').setup()
        '';
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require('Comment').setup()
        '';
      }
      todo-txt-vim

      {
        plugin = neogit;
        type = "lua";
        config = ''
          require('neogit').setup()
        '';
      }

      {
        plugin = nvim-ts-rainbow2;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup {
            rainbow = {
              enable = true,
              query = 'rainbow-parens',
              strategy = require('ts-rainbow').strategy.global,
            }
          }
        '';
      }
    ];
    extraPackages = with pkgs; [
      tree-sitter
      # Nix
      rnix-lsp
      # C
      clang-tools
      # Rust
      rust-analyzer
      rustfmt
      # TypeScript
      nodePackages.typescript
      nodePackages.typescript-language-server
      # LaTeX
      texlab
      # Python
      python3Packages.ruff-lsp
      # Haskell
      haskell-language-server
    ];
  };
}
