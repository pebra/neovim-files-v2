require("pi").setup({
  binary = "/Users/peterbrandel/.local/state/tec/profiles/base/current/global/bin/pi", -- or { "env", "FOO=1", "pi-wrapper" }
  -- provider = "openrouter",
  -- model = "openrouter/free",
  -- thinking = "on", -- be careful, thinking is time-consuming, it's not a great experience if you want simplicity
  -- system_prompt = "You are a helpful assistant.",
  -- append_system_prompt = "Always respond concisely.",
  -- context = {
  --   max_bytes = 24000,
  --   ask = {
  --     surrounding_lines = 80,
  --   },
  --   selection = {
  --     surrounding_lines = 40,
  --   },
  --   diagnostics = {
  --     enabled = false,
  --   },
  -- },
  -- skills = true,
  -- extensions = true,
})

-- Ask pi with the current buffer as context
vim.keymap.set("n", "<leader>aia", ":PiAsk<CR>", { desc = "Ask pi" })

-- Ask pi with visual selection as context
vim.keymap.set("v", "<leader>aia", ":PiAskSelection<CR>", { desc = "Ask pi (selection)" })
