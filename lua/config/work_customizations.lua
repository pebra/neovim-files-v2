-- replacing gh-line-plugin
--
local function get_git_root()
	local root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
	return root ~= '' and root or nil
end

local function get_canonical_ref()
	local sha = vim.fn.system('git rev-parse HEAD 2>/dev/null'):gsub('\n', '')
	return sha ~= '' and sha or 'main'
end

local function get_relative_path()
	local git_root = get_git_root()
	if not git_root then return nil end
	local abs_path = vim.fn.expand('%:p')
	return abs_path:gsub('^' .. vim.pesc(git_root) .. '/', '')
end

local function generate_github_link(mode, is_blame)
	local rel_path = get_relative_path()
	if not rel_path then
		print('Not in a git repository')
		return
	end

	local ref = get_canonical_ref()
	local start_line, end_line

	if mode == 'v' then
		start_line = vim.fn.line("'<")
		end_line = vim.fn.line("'>")
	else
		start_line = vim.fn.line('.')
		end_line = start_line
	end

	local line_fragment
	if start_line == end_line then
		line_fragment = '#L' .. start_line
	else
		line_fragment = '#L' .. start_line .. '-L' .. end_line
	end

	local path_type = is_blame and 'blame' or 'blob'
	local url = string.format(
		'https://github.com/shop/world/%s/%s/%s%s',
		path_type,
		ref,
		rel_path,
		line_fragment
	)

	vim.fn.setreg('+', url)
	print('Copied: ' .. url)
end

-- Normal mode commands
vim.api.nvim_create_user_command('GHLine', function()
	generate_github_link('n', false)
end, {})

vim.api.nvim_create_user_command('GHBlame', function()
	generate_github_link('n', true)
end, {})

-- Visual mode commands
vim.api.nvim_create_user_command('GHLineVisual', function()
	generate_github_link('v', false)
end, { range = true })

vim.api.nvim_create_user_command('GHBlameVisual', function()
	generate_github_link('v', true)
end, { range = true })

-- Key mappings
vim.keymap.set('n', '<leader>ghl', '<cmd>GHLine<cr>', { desc = 'Copy GitHub line link' })
vim.keymap.set('v', '<leader>ghl', '<cmd>GHLineVisual<cr>', { desc = 'Copy GitHub line range link' })
vim.keymap.set('n', '<leader>ghb', '<cmd>GHBlame<cr>', { desc = 'Copy GitHub blame link' })
vim.keymap.set('v', '<leader>ghb', '<cmd>GHBlameVisual<cr>', { desc = 'Copy GitHub blame link' })
