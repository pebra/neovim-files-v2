-- Function to update OpenAI key
function UpdateOpenAIKey()
	vim.fn.system('openai_key update')
	print("OpenAI key updated.")
end

-- Command to call the function
vim.api.nvim_create_user_command('UpdateOpenAIKey', UpdateOpenAIKey, {})

vim.api.nvim_set_keymap('n', '<leader>au', ':lua UpdateOpenAIKey()<CR>', { noremap = true, silent = true })
