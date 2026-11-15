-- Android / KMP tooling (build, run, logcat, AVDs, Gradle tasks)
-- https://github.com/iamironz/android-nvim-plugin
require("android").setup({
  -- The SDK is auto-detected from ANDROID_SDK_ROOT / ANDROID_HOME or the
  -- project's local.properties. Override it here if you keep the SDK elsewhere:
  -- sdk = { root = vim.fn.expand("~/Library/Android/sdk") },

  -- Defaults are sane; tweak as needed.
  ui = {
    file_watcher = true,
    autosave = true,
    restore_logcat = true,
  },
  keymaps = {
    enabled = true,
    mappings = {
      menu = "<leader>am",
      targets = "<leader>at",
      tools = "<leader>ao",
      actions = "<leader>aa",
      build = "<leader>ab",
    },
  },
})
