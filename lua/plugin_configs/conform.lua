-- Formatting via conform.nvim
-- https://github.com/stevearc/conform.nvim
local ok, conform = pcall(require, "conform")
if not ok then
  return
end

-- Pick the first available Kotlin formatter. When none is installed we fall
-- back to whatever the language server offers (the official kotlin-lsp ships
-- IntelliJ's formatter).
local kotlin_formatters = {}
if vim.fn.executable("ktlint") == 1 then
  kotlin_formatters = { "ktlint" }
elseif vim.fn.executable("ktfmt") == 1 then
  kotlin_formatters = { "ktfmt" }
end

local lua_formatters = {}
if vim.fn.executable("stylua") == 1 then
  lua_formatters = { "stylua" }
end

conform.setup({
  formatters_by_ft = {
    kotlin = kotlin_formatters,
    lua = lua_formatters,
  },
  -- "fallback" -> only use the LSP formatter when no external formatter applies.
  default_format_opts = {
    lsp_format = "fallback",
  },
  -- Uncomment to format on every save:
  -- format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
})

vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  conform.format({ async = true, lsp_format = "fallback" }, function(err)
    if err then
      vim.notify("Format failed: " .. err, vim.log.levels.ERROR)
    end
  end)
end, { desc = "Format buffer" })
