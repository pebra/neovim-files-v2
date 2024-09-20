-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local lga_actions = require("telescope-live-grep-args.actions")

require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = { width = 0.9 },
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = {         -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          -- freeze the current list and start a fuzzy search in the frozen list
          ["<C-space>"] = lga_actions.to_fuzzy_refine,
        },
      },
      file_browser = {
        theme = "ivy"
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    },
  },
  -- extensions = {
  --   file_browser = {
  --     theme = "ivy"
  --   }
  -- }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>pb', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>pf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ph', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>pg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>pd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set("n", '<leader>pgg',require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[S]earch by [R]ipGrep' })


-- find notes
vim.keymap.set("n", "<leader>fn", [[<Cmd>lua require'plugin_configs.telescope'.find_notes()<CR>]], { noremap = true, silent = true })
-- search notes
vim.keymap.set("n", "<space>gn", [[<Cmd>lua require'plugin_configs.telescope'.grep_notes()<CR>]], { noremap = true, silent = true })


-- credits to https://github.com/whatsthatsmell/dots/tree/master
local M = {}

function M.grep_notes()
  local opts = {}
  opts.hidden = true
  opts.search_dirs = {
    "~/Sync/Docs/notes/",
  }
  opts.prompt_prefix = "   "
  opts.prompt_title = " Grep Notes"
  opts.path_display = { "smart" }
  require("telescope.builtin").live_grep(opts)
end

function M.find_notes()
  require("telescope.builtin").find_files {
    prompt_title = " Find Notes",
    path_display = { "smart" },
    cwd = "~/Sync/Docs/notes/",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 },
  }
end

function M.browse_notes()
  require("telescope").extensions.file_browser.file_browser {
    prompt_title = " Browse Notes",
    prompt_prefix = " ﮷ ",
    cwd = "~/Sync/Docs/notes/",
    layout_strategy = "horizontal",
    layout_config = { preview_width = 0.65, width = 0.75 },
  }
end


return M
