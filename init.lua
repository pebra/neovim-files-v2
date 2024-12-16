local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = ' '

require("lazy").setup({
  -- Tim Pope goodness
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',
  {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require 'mind'.setup()
    end
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- ft = { "scala", "sbt", "java" },
    -- opts = function()
    --   local metals_config = require("metals").bare_config()
    --   metals_config.on_attach = function(client, bufnr)
    --     -- your on_attach function
    --   end
    --
    --   return metals_config
    -- end,
    -- config = function(self, metals_config)
    --   local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    --   vim.api.nvim_create_autocmd("FileType", {
    --     pattern = self.ft,
    --     callback = function()
    --       require("metals").initialize_or_attach(metals_config)
    --     end,
    --     group = nvim_metals_group,
    --   })
    -- end
  },
  {
    'ruanyl/vim-gh-line',
    init = function(_)
      vim.g.gh_line_map_default = 0
      vim.g.gh_line_map = "<leader>ghl"
      vim.g.gh_line_blame_map = "<leader>ghb"
      vim.g.gh_use_canonical = 1
    end,
  },
  -- Colors
  {
    "rktjmp/lush.nvim",
    -- if you wish to use your own colorscheme:
    -- { dir = '/absolute/path/to/colorscheme', lazy = true },
  },
  'rebelot/kanagawa.nvim',
  'sainnhe/everforest',
  'EdenEast/nightfox.nvim',
  {
    "mstcl/ivory",
  },
  {
    'Iron-E/nvim-highlite',
    config = function(_, _)
      -- OPTIONAL: setup the plugin. See "Configuration" for information
      require('highlite').setup { generator = { plugins = { vim = false }, syntax = false } }
    end,
    lazy = false,
    priority = math.huge,
    version = '^4.0.0',
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  -- lsp
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
  { 'neovim/nvim-lspconfig' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  { 'saadparwaiz1/cmp_luasnip' },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',   opts = {} },
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-live-grep-args.nvim' },
    config = function(_)
      require("telescope").load_extension("live_grep_args")
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
  },
  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  {
    'realprogrammersusevim/md-to-html.nvim',
    cmd = { 'MarkdownToHTML', 'NewMarkdownToHTML' },
  },
  -- openscad
  {
    'salkin-mada/openscad.nvim',
    config = function(_)
      require('openscad')
      -- load snippets, note requires
      vim.g.openscad_load_snippets = true
    end,
    requires = 'L3MON4D3/LuaSnip'
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function() require("copilot_cmp").setup() end,
    dependencies = {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    },
  },
  -- nvim org mode
  {
    'nvim-orgmode/orgmode',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
    },
    event = 'VeryLazy',
    config = function()
      -- Setup treesitter
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'org' },
        },
        ensure_installed = { 'org' },
      })

      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/Documents/*.org',
        org_default_notes_file = '~/refile.org',
      })
    end,
  },
  'aserowy/tmux.nvim',
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  }
})

-- set colorscheme
vim.cmd.colorscheme('kanagawa')
-- Set highlight on search
vim.o.hlsearch = true
-- Make line numbers default
vim.wo.number = true
-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

require("config.listchars")
require("plugin_configs.telescope")
require("plugin_configs.lsp")
require("plugin_configs.cmp")
require("plugin_configs.telescope_file_browser")
require("plugin_configs.treesitter")
require("plugin_configs.openscad")
