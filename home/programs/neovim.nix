{ unstable-pkgs, config, ... }:
{
  programs.neovim = {
    enable = true;
    package = unstable-pkgs.neovim-unwrapped; # use unstable Neovim to get new features from 0.10
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
      vim.opt.signcolumn = "yes"

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

      -- Clipboard
      vim.keymap.set('n', '<leader>y', '"+y')
      vim.keymap.set('v', '<leader>y', '"+y')
      vim.keymap.set('n', '<leader>p', '"+p')
      vim.keymap.set('n', '<leader>P', '"+P')
      vim.keymap.set('v', '<leader>p', '"+p')
      vim.keymap.set('v', '<leader>P', '"+P')
    '';
    plugins = with unstable-pkgs.vimPlugins; [
      {
        plugin = nightfox-nvim;
        type = "lua";
        config = ''
          require('nightfox').setup({
            options = {
              transparent = true,
            }
          })
          vim.opt.background = "dark"
          vim.cmd("colorscheme nightfox")
          vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        '';
      }

      plenary-nvim
      # Telescope
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<C-p>', builtin.find_files, {})
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
        plugin = telescope-fzf-native-nvim;
        type = "lua";
        config = ''
          require('telescope').load_extension('fzf')
        '';
      }
      {
        plugin = telescope-file-browser-nvim;
        type = "lua";
        config = ''
          vim.api.nvim_set_keymap("n", "<leader>k", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
          vim.api.nvim_set_keymap("n", "<leader>f", ":Telescope file_browser<CR>", { noremap = true })
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
        plugin = (
          unstable-pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
            p.c
            p.cpp
            p.css
            p.haskell
            p.html
            p.java
            p.javascript
            p.json
            p.latex
            p.lua
            p.markdown
            p.nix
            p.org
            p.org
            p.rust
            p.svelte
            p.toml
            p.typescript
            p.xml
          ])
        );
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup {
            ignore_install = { 'org' }, -- Solves conflict with nvim-orgmode
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
      {
        plugin = nvim-treesitter-context;
        type = "lua";
        config = ''
          require('treesitter-context').setup()
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
          vim.lsp.set_log_level("info")

          local lspconfig = require('lspconfig')

          -- Language servers
          -- lspconfig.rust_analyzer.setup{} -- handled by rustaceanvim
          lspconfig.ts_ls.setup{}
          lspconfig.clangd.setup{
            cmd = { "clangd", "--background-index", "--clang-tidy" },
            init_options = {
              fallbackFlags = { "-std=c++26" },
            },
          }
          lspconfig.nil_ls.setup({
            settings = {
              ['nil'] = {
                formatting = {
                  command = { "nixfmt" },
                },
              },
            },
          })
          lspconfig.texlab.setup{}
          lspconfig.ruff.setup{}
          lspconfig.hls.setup{}
          lspconfig.svelte.setup{}
          lspconfig.zls.setup{}

          -- Diagnostics
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostics" })

          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
              local opts = { buffer = ev.buf }
              -- Documentation
              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
              vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

              -- Goto
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
              vim.keymap.set("n", "gi", require('telescope.builtin').lsp_implementations, opts)
              vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
              vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references, opts)
              vim.keymap.set("n", "gs", require('telescope.builtin').lsp_document_symbols, opts)
              vim.keymap.set("n", "gS", require('telescope.builtin').lsp_workspace_symbols, opts)

              vim.keymap.set("n", "g.", vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
              vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
            end,
          })
        '';
      }

      nvim-web-devicons
      trouble-nvim
      {
        plugin = rustaceanvim;
        type = "lua";
        config = ''
          vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {
            },
            -- LSP configuration
            server = {
              on_attach = function(client, bufnr)
                -- Enable inlay hints
                vim.lsp.inlay_hint.enable(true)
              end,
              settings = {
                -- rust-analyzer language server configuration
                ['rust-analyzer'] = {
                  -- TODO: Only do this per project
                  -- rustfmt = {
                  --     overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
                  -- },
                },
              },
            },
            -- DAP configuration
            dap = {
            },
          }
        '';
      }
      {
        plugin = nvim-jdtls;
        type = "lua";
        config = ''
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              local config = {
                  cmd = {'${unstable-pkgs.jdt-language-server}/bin/jdtls'},
                  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
              }
              require('jdtls').start_or_attach(config)
            end,
          })
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
           \ 'markdown': v:false,
           \ 'text': v:false,
           \ 'tex': v:false,
           \ 'xml': v:false,
           \ 'todo': v:false,
           \ 'org': v:false,
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
      {
        plugin = orgmode;
        type = "lua";
        config =
          let
            palette = config.colorScheme.palette;
          in
          ''
            require('orgmode').setup{
              org_agenda_files = {'~/docs/org/**/*'},
              org_todo_keyword_faces = {
                TODO = ':foreground #${palette.base08} :weight bold',
                DONE = ':foreground #${palette.base0B} :weight bold',
              },
              org_default_notes_file = '~/docs/org/notes.org',
              org_startup_indented = true,
              org_hide_leading_stars = true,
              org_deadline_warning_days = 5,
            }
          '';
      }

      {
        plugin = image-nvim; # required for latex rendering
        type = "lua";
        config = ''
          require('image').setup()
        '';
      }
      {
        plugin = neorg;
        type = "lua";
        config = ''
          require("neorg").setup({
            load = {
              ["core.defaults"] = {},
              ["core.concealer"] = {},
              ["core.export"] = {},
              ["core.export.markdown"] = {},
              ["core.integrations.image"] = {},
              ["core.autocommands"] = {},
              ["core.highlights"] = {},
              ["core.integrations.treesitter"] = {},
              ["core.neorgcmd"] = {},
              ["core.latex.renderer"] = {},
            }
          })
          vim.keymap.set('n', '<leader>e', ':w | :Neorg export to-file out.md<CR>', { noremap = true })
        '';
      }
    ];
    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = with unstable-pkgs; [
      tree-sitter
      imagemagick # for image.nvim
      # Nix
      nil
      nixfmt-rfc-style
      # C/C++
      clang-tools
      # Rust
      rust-analyzer
      rustfmt
      # TypeScript
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.svelte-language-server # Svelte
      # LaTeX
      texlab
      # Python
      ruff-lsp
      # Haskell
      haskell-language-server
      # Java
      jdt-language-server
      # Zig
      zls
      # Latex
      (texlive.combine {
        inherit (texlive)
          scheme-basic
          amsmath
          dvipng
          hyperref
          ;
      })
    ];
  };
}
