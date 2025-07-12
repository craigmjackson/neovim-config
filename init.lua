-- Options
-- Set the leader key to <Space> in normal mode
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- If you have a nerd font, set this to true
-- otherwise, your terminal will have garbage characters
vim.g.have_nerd_font = true
-- Enable line numbers on the left
vim.opt.number = true
-- Enable relative numbers.
-- Press the number and up/down (or k/j)
vim.opt.relativenumber = true
-- Enable mouse support.
-- Hold down <Shift> when clicking to disable mouse selection.
vim.opt.mouse = 'nvi'
-- No need to shot the mode in the command line because it's in the statusline above it
vim.opt.showmode = false
-- Improve startup time significantly by deferring the clipboard support from the OS
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
-- Make sure indenting doesn't start at column 0 which is tough to tgead
vim.opt.breakindent = true
-- Make undo files so undo can be done after Neovim is closed
vim.opt.undofile = true
-- Make searches case-insensitive
vim.opt.ignorecase = true
-- However, if you have a mix of case in your search term, make it case-sensitive
vim.opt.smartcase = true
-- Show the sign column (where gitsigns are displayed) only if there is content to display
vim.opt.signcolumn = 'auto'
-- Write the swapfile to disk if nothing is typed for 250 milliseconds
vim.opt.updatetime = 250
-- How long to wait for a mapped sequence to complete before timing out
vim.opt.timeoutlen = 300
-- For horizontal splits, put the new window on the right
vim.opt.splitright = true
-- For vertical splits, put the new window below
vim.opt.splitbelow = true
-- Show subtitution results in preview window
vim.opt.inccommand = 'split'
-- Highlight the line you are on
vim.opt.cursorline = true
-- Force a minimum number of lines above and below the cursor
vim.opt.scrolloff = 10
-- Enable 256 colors in text mode
vim.opt.termguicolors = true
-- Enable transparency for some floating windows
vim.opt.winblend = 30
-- Supress navic complaining it can't control certain windows
vim.g.navic_silence = true
-- Uncomment below if you need to debug your LSP
-- vim.lsp.set_log_level 'TRACE'

-- General Keymaps
-- Clear search highlighting by pressing <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Open a list of all the quickfix messages in this file
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Autocommands
-- Highlight text as it is yanked
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Automatically clone and install lazy.nvim plugin manager if it is not installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim and its plugins
require('lazy').setup({
  -- Automatically detect in each file based on current indenting:
  --   tabstop (how many spaces per tab)
  --   shiftwidth (how many spaces to automatically indent)
  'tpope/vim-sleuth',
  {
    -- Enable git signs in the left signcolumn
    'lewis6991/gitsigns.nvim',
    opts = {
      -- Set which characters indicate which state
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    -- Help you with the availble key mappings as you type them
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        -- Specify mapping key symbols if you don't a nerd font
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      -- Specify general categories
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  {
    -- Fuzzy finder, including a UI to display the results
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      -- General purpose asynchronous routine library for Neovim
      'nvim-lua/plenary.nvim',
      {
        -- Use a higher performance fzf algorithms library
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      -- Include the UI components to draw the pop-up windows
      { 'nvim-telescope/telescope-ui-select.nvim' },
      -- Enable icons if they are provided by a nerd font
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        -- Include telescope themes in the UI
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      -- Load the telescope extensions
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      local builtin = require 'telescope.builtin'
      -- Enable some common telescope keymaps
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      -- Search your whole project
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      -- Go back to the previous search
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      -- Fuzzy search in the current buffer
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      -- Search through all your open buffers
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
      -- Search for your Neovim config files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    -- Enable LSP for neovim APIs in Lua
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Enable nvim-lspconfig which wraps around manual NeoVim LSP configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- mason.nvim will install your LSPs automatically when
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Enable cmp to handle completions for some LSP servers
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Run this autocommand on attaching to a buffer that supports an LSP
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          -- Helper function to map the mode, buffer, and description for various functions
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          -- Jumps to wherever in the project the function is defined
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          -- Find other references in the project of the word under your cursor
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          -- Jump to implementation, as opposed to declaration, if your code has both
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          -- Get the definition of the type of the variable under the cursor
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          -- Fuzzy find through all the symbols in your document
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          -- Fuzzy find through all the symbols in your project
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          -- Rename the variable under the cursor across the project
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          -- Execute a code action such as a quick fix for a known deprecation
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          -- Jump to the declaration, as opposed to the implementation, if your code has both
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          -- Make this config file compatible with both nightly (0.11) and stable (0.10)
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end
          -- If you rest your cursor on a word, hightlight all the other references to that word
          -- Moving your cursor will remove the highlight
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end
          -- Alloow toggling inline-hints since they might be too long or displace your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
      vim.diagnostic.config {
        -- Sort diagnostic messages by severity
        severity_sort = true,
        -- Style the floating window
        float = { border = 'rounded', source = 'if_many' },
        -- Underline any errors
        underline = { severity = vim.diagnostic.severity.ERROR },
        -- Configure diagnostic symbols if nerd font is available
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        -- Configure virtual text for the inline diagnostic messages
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }
      -- Advertised the extra LSP client capabilities gained by new plugins
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      -- Define a table of language servers to install
      -- Visit https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md to get
      -- a list of available servers and how to configure them.  List is also availble in
      -- Neovim with :help lspconfig-all
      local servers = {
        pyright = {},
        bashls = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        clangd = {},
      }
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })
      -- Install the defined servers
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        ensure_installed = {},
        -- Set this to true to automatically download and install an LSP server if entering a
        -- new buffer that doesn't yet have a server installed.
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            -- Run the setup for any of the defined servers
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
      -- Setup special config to support Vue files which contain both HTML and JavaScript
      local lspconfig = require 'lspconfig'
      lspconfig.volar.setup {
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      }
      -- Need to add @vue/language-server, typescript, and @vue/typescript-plugin to local project
      lspconfig.ts_ls.setup {
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = './node_modules/@vue/typescript-plugin',
              languages = { 'vue' },
            },
          },
        },
        filetypes = {
          'typescript',
          'javascript',
          'javascriptreact',
          'typescriptreact',
          'vue',
        },
      }
    end,
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      -- If some file format isn't supported, don't spam the user
      notify_on_error = false,
      -- Automatically format on saving
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 5000,
          lsp_format = lsp_format_opt,
        }
      end,
      -- Specify formatter to use for each filetype
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        javascript = { 'prettier' },
      },
    },
  },
  {
    -- Autocomplete
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        -- Snippet engine to handle the completion
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            -- A variety of premade snippets
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      -- Snippets for Lua
      'saadparwaiz1/cmp_luasnip',
      -- Include other modules for cmp
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text',
          },
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          -- Next item can be <Ctrl-n> or just <Down>
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<Down>'] = cmp.mapping.select_next_item(),
          -- Previous item can be <Ctrl-p> or just <Up>
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<Up>'] = cmp.mapping.select_prev_item(),
          -- Scrolling up the docs in a completion can be <Ctrl-b> or <PageUp>
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<PageUp>'] = cmp.mapping.scroll_docs(-4),
          -- Scrolling down the docs in a completion can be <Ctrl-f> or <PageDown>
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<PageDown>'] = cmp.mapping.scroll_docs(4),
          -- Confirming the selected item can be <Ctrl-y>, <Tab>, or <Enter>
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.confirm {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        },
      }
    end,
  },
  {
    'askfiy/visual_studio_code',
    priority = 100,
    config = function()
      vim.cmd [[colorscheme visual_studio_code]]
    end,
  },
  -- Highlight TODOs in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    -- A collection of small plugins
    'echasnovski/mini.nvim',
    config = function()
      -- Extra functions and mappings for Around/Inside text objects
      require('mini.ai').setup { n_lines = 500 }
      -- Extra functions and mappings for Add/Delete/Replace surroudings (brackets, quotes, braces, parens)
      require('mini.surround').setup()
      -- Basic statusline
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    -- Highlighting, editing, and navigation of your code in the current file
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      -- Install support for these languages at startup if not already installed
      ensure_installed = {
        'javascript',
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'css',
        'yaml',
        'json',
        'dockerfile',
        'python',
        'php',
      },
      -- Install more treesitter configs as needed when new filetypes are opened
      auto_install = true,
      -- Enable highlighting
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      -- Enable auto-indenting
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  {
    -- Breadcrumbs bar at the top to help navigate your tree
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('barbecue').setup()
    end,
  },
  -- Automatically add the closing pair of paren, bracket, curly brace, quotes
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    -- Tabs support at top
    --
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          numbers = 'ordinal',
          separator_style = 'slant',
          buffer_close_icon = vim.g.have_nerd_font and '' or 'x',
          close_icon = vim.g.have_nerd_font and '' or 'x',
          modified_icon = vim.g.have_nerd_font and '' or 'm',
          left_trunc_marker = vim.g.have_nerd_font and '' or '/',
          right_trunc_marker = vim.g.have_nerd_font and '' or '\\',
        },
      }
      -- Goto buffer number with <Space> b #<Enter>
      vim.keymap.set('n', '<leader>b', ':BufferLineGoToBuffer ', { desc = 'Open [B]uffer (tab) Number' })
      -- Goto next buffer with <Space> <Tab>
      vim.keymap.set('n', '<leader><Tab>', ':BufferLineCycleNext<CR>', { desc = 'Cycle next tab' })
      -- Goto previous tab with <Space> <Shift-Tab>
      vim.keymap.set('n', '<leader><Shift-Tab>', ':BufferLineCyclePrev<CR>', { desc = 'Cycle previous tab' })
      -- Also, you can close the current buffer (tab) with :bd
    end,
  },
  {
    -- File manager
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        disable_netrw = true,
        hijack_netrw = true,
        renderer = {
          icons = {
            web_devicons = {
              file = {
                enable = vim.g.have_nerd_font,
                color = true,
              },
              folder = {
                enable = vim.g.have_nerd_font,
                color = true,
              },
            },
            glyphs = vim.g.have_nerd_font and {} or {
              default = '',
              symlink = '',
              bookmark = '',
              modified = 'm',
              hidden = '',
              folder = {
                arrow_closed = '>',
                arrow_open = 'v',
                default = 'd',
                open = 'd',
                empty = 'd',
                empty_open = 'd',
                symlink = 'ds',
                symlink_open = 'ds',
              },
              git = {
                unstaged = '',
                staged = 's',
                unmerged = '',
                untracked = '',
                deleted = 'd',
                ignored = '',
              },
            },
          },
        },
        filters = {
          git_ignored = false,
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      }
      -- Use <Ctrl-n> to toggle the file manager on the left
      vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree ' })
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup {
        handlers = {
          gitsigns = true,
        },
      }
    end,
  },
  {
    -- Render markdown.
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    opts = {},
    config = function()
      require('render-markdown').setup {
        completions = { lsp = { enabled = true } },
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'markdown',
          callback = function(opts)
            if vim.bo[opts.buf].filetype == 'markdown' then
              vim.cmd 'RenderMarkdown enable'
            end
          end,
        }),
      }
    end,
  },
  {
    -- Zen mode for focused coding
    'folke/zen-mode.nvim',
    config = function()
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          vim.keymap.set('n', '<leader>z', ':ZenMode<CR>', { desc = '[Z]en Mode' })
        end,
      })
    end,
  },
  {
    'hedyhli/outline.nvim',
    config = function()
      vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Tiggle [O]utline' })
      require('outline').setup()
    end,
  },
}, {
  ui = {
    -- Define icons if you have a nerd font
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
