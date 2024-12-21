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

vim.api.nvim_set_hl(0, 'Whitespace', { fg='grey20' })
