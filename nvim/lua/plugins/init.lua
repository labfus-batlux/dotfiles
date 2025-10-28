-- Plugin specifications for lazy.nvim
-- This file is required by init.lua via: require('lazy').setup('plugins')

local function detect_appearance()
  local env_theme = os.getenv('WARP_THEME') or os.getenv('NVIM_THEME')
  if env_theme then
    env_theme = env_theme:lower()
    if env_theme:find('light') then return 'light' end
    if env_theme:find('dark') then return 'dark' end
  end
  if vim.fn.has('mac') == 1 then
    local ok, out = pcall(vim.fn.system, { 'defaults','read','-g','AppleInterfaceStyle' })
    if ok and type(out) == 'string' and out:match('Dark') then return 'dark' end
    return 'light'
  end
  return 'dark'
end

local appearance = detect_appearance()

return {
  -- THEME (loads first)
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local variant = (appearance == 'light') and 'tokyonight-day' or 'tokyonight-moon'
      require('tokyonight').setup({
        style = (appearance == 'light') and 'day' or 'moon',
        transparent = true,
        styles = { sidebars = 'transparent', floats = 'transparent' },
      })
      vim.cmd.colorscheme(variant)
    end,
  },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'rebelot/kanagawa.nvim' },

  -- UI/UX
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({ options = { theme = 'auto', globalstatus = true } })
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup({ options = { diagnostics = 'nvim_lsp' } })
    end,
  },
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({})
    end,
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end,
  },
  { 'stevearc/dressing.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = { scope = { enabled = true }, indent = { char = '│' } },
  },
  {
    'folke/noice.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    opts = { presets = { bottom_search = true, command_palette = true, lsp_doc_border = true } },
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'vim', 'vimdoc', 'bash', 'javascript', 'typescript', 'tsx', 'json', 'yaml', 'toml', 'html', 'css', 'markdown', 'markdown_inline', 'python', 'go', 'rust', 'gitignore' },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
      })
    end,
  },

  -- Core editing
  { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end },
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
  { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end },

  -- Telescope
  { 'nvim-lua/plenary.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup({ defaults = { mappings = { i = { ['<C-k>'] = 'move_selection_previous', ['<C-j>'] = 'move_selection_next' } } } })
      pcall(telescope.load_extension, 'fzf')
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    end,
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable('make') == 1 },

  -- LSP + Completion + Formatting
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim', config = function() require('mason').setup() end },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'L3MON4D3/LuaSnip', version = 'v2.*' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'j-hui/fidget.nvim', tag = 'legacy', config = true },
  {
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return { timeout_ms = 500, lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype] }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier' },
        typescript = { 'prettierd', 'prettier' },
        json = { 'jq', 'prettierd', 'prettier' },
        yaml = { 'yamlfmt', 'prettier' },
        markdown = { 'prettierd', 'prettier' },
        python = { 'ruff_format' },
        go = { 'gofumpt', 'goimports' },
        rust = { 'rustfmt' },
      },
    },
  },
  {
    'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig', 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip'
    },
    config = function()
      local lsp = require('lsp-zero')
      lsp.extend_lspconfig()
      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
      end)
      lsp.setup()

      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' } }, { { name = 'buffer' }, { name = 'path' } }),
      })

      local lspconfig = require('lspconfig')
      local servers = { 'lua_ls', 'tsserver', 'pyright', 'gopls', 'rust_analyzer', 'bashls', 'jsonls', 'yamlls', 'html', 'cssls' }
      for _, s in ipairs(servers) do lspconfig[s].setup({}) end

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
    end,
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({})
      vim.keymap.set('n', '<leader>e', vim.cmd.NvimTreeToggle, { desc = 'Toggle file explorer' })
    end,
  },

  -- Navigation/productivity
  { 'folke/flash.nvim', opts = {} },
  {
    'ThePrimeagen/harpoon', branch = 'harpoon2', dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()
      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon add file' })
      vim.keymap.set('n', '<leader>ha', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
      for i = 1, 5 do
        vim.keymap.set('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon file ' .. i })
      end
    end,
  },
}
