local opt = vim.opt

opt.cursorline = true

opt.list = true

local space = "•"
opt.listchars:append {
	tab = "│─",
	multispace = space,
	lead = space,
	trail = space,
	nbsp = space
}

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
vim.o.timeout = false
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = false })
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

-- Format buffer as JSON
vim.keymap.set('n', '<leader>fj', ':%!jq .<CR>', { desc = "Format buffer as JSON" })

-- set ruby host dynamically
if vim.env.RUBY_ROOT then
	vim.g.ruby_host_prog = vim.env.RUBY_ROOT
elseif vim.env.RUBY_VERSION then
	vim.g.ruby_host_prog = "/opt/rubies/" .. vim.env.RUBY_VERSION .. "/"
end

vim.api.nvim_set_hl(0, 'Whitespace', { fg = 'grey18' })


-- Map <leader>fc to the copy_file_path function
local function copy_file_path()
	local file_path = vim.fn.expand('%')
	if file_path ~= '' then
		vim.fn.setreg('+', file_path)
		vim.notify('Copied: ' .. file_path)
	else
		vim.notify('Buffer has no associated file', vim.log.levels.WARN)
	end
end
vim.keymap.set('n', '<leader>fc', copy_file_path, { desc = '[F]ile [C]opy Path' })
--
