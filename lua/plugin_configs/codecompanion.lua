-- local openai_key_path = vim.fn.expand("~/bin/openai_key")
local openai_cmd = "cmd:/opt/dev/bin/devx llm-gateway print-token --key"

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-lua/plenary.nvim" },
    { "hrsh7th/nvim-cmp" },
  },
  event = "BufEnter",
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "x" }, desc = "CodeCompanion Actions" },
    { "<leader>ac", "<cmd>CodeCompanionChat<cr>",    mode = { "n", "x" }, desc = "CodeCompanion Chat" },
    { "<leader>ap", "<cmd>CodeCompanion<cr>",        mode = { "n", "x" }, desc = "CodeCompanion in prompt" },
  },
  init = function()
    local openai = require("codecompanion.adapters.openai")

    local function adapter(base_name, url, model)
      local base = require("codecompanion.adapters." .. base_name)

      return require("codecompanion.adapters").extend(base, {
        url = url,
        env = {
          api_key = openai_cmd,
        },
        handlers = openai.handlers,
        headers = openai.headers,
        parameters = {
          model = "${model}",
        },
        schema = {
          model = {
            default = model or base.schema.model.default,
          },
        },
      })
    end

    require("codecompanion").setup({
      opts = {
        log_level = "DEBUG", -- or "TRACE"
      },
      adapters = {
        opts = {
          show_defaults = false,
        },
        anthropic = adapter("anthropic", "https://proxy.shopify.ai/v1/chat/completions", "anthropic:claude-3-7-sonnet"),
        gemini = adapter("gemini", "https://proxy.shopify.ai/v1/chat/completions", "google:gemini-2.5-pro"),
        huggingface = adapter(
          "huggingface",
          "https://proxy.shopify.ai/v1/chat/completions",
          "huggingface:meta-llama/Meta-Llama-3.1-70B-Instruct"
        ),
        openai = adapter("openai", "https://proxy.shopify.ai/vendors/openai/v1/chat/completions"),
      },
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
    })
  end,
}
