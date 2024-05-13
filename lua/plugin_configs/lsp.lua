local lsp_zero = require('lsp-zero')
require('lspconfig').intelephense.setup({})

lsp_zero.on_attach(function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- lsp_zero.default_keymaps({buffer = bufnr})

  nmap('<leader>lrn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>lca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('<leader>lgd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('<leader>lgr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>lgi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>lgt', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('<leader>lK', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('<leader>lf', function()
    vim.lsp.buf.format { async = true }
  end)

  -- Lesser used LSP functionality
  nmap('<leader>lgD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'rust_analyzer', 'ruby_lsp', 'elixirls', 'lua_ls'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})
