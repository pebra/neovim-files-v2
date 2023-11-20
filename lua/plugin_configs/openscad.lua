local openscad = require('openscad')

-- vim.g.openscad_cheatsheet_toggle_key = '<Enter>'
-- vim.g.openscad_help_trig_key = '<A-h>'
-- vim.g.openscad_help_manual_trig_key = '<A-m>'
-- vim.g.openscad_exec_openscad_trig_key = '<A-o>'
-- vim.g.openscad_top_toggle = '<A-c>'

-- local nmap = function(keys, func, desc)
--   if desc then
--     desc = 'LSP: ' .. desc
--   end
--
--   vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
-- end
-- nmap('<leader>sco', openscad.openscad_exec_openscad_trig_key, '[S]cad[o]open')
-- vim.keymap.set('n', '<leader>sco', openscad.openscad_exec_openscad_trig_key)
vim.g.openscad_exec_openscad_trig_key = '<leader>sco'
-- nmap('<leader>lgr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
