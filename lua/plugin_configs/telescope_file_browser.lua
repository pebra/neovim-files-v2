require("./telescope").load_extension("file_browser")

vim.api.nvim_set_keymap(
  "n",
  "<space>pt",
  ":Telescope file_browser<CR>",
  { noremap = true }
)

-- open file_browser with the path of the current buffer
vim.api.nvim_set_keymap(
  "n",
  "<space>pc",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)

