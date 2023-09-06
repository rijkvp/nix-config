{ config, pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = ''
      -- Disable netrw (replaced by nvim-tree)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.opt.nu = true
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 8

      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true

      vim.opt.smartindent = true

      vim.opt.wrap = false
      vim.opt.linebreak = true

      vim.opt.spelllang = { 'en_us' }

      vim.opt.swapfile = false
      vim.opt.backup = false
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.undofile = true

      vim.opt.hlsearch = true
      vim.opt.incsearch = true

      vim.cmd("set clipboard+=unnamedplus");

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
          vim.cmd[[colorscheme catppuccin]]
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
          lspconfig.rust_analyzer.setup{}
          lspconfig.tsserver.setup{}
          lspconfig.clangd.setup{}
          lspconfig.rnix.setup{}
          lspconfig.texlab.setup{}
          lspconfig.ruff_lsp.setup{}
          lspconfig.hls.setup{}

          -- Goto
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
          vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })

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

      # File manager
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup()
          vim.keymap.set('n', '<leader>o', vim.cmd.NvimTreeToggle, { desc = "Toggle file tree" })
        '';
      }

      # Completion
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
              ['<C-e>'] = cmp.mapping.close(),
              ['<C-y>'] = cmp.mapping.confirm(),
            },
            sources = {
              { name='nvim_lsp' },
              { name='buffer', option = { get_bufnrs = vim.api.nvim_list_bufs } },
            },
          }
        '';
      }
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-spell
      lspkind-nvim

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
      copilot-vim

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
      python311Packages.ruff-lsp
      # Haskell
      haskell-language-server
    ];
  };
}
