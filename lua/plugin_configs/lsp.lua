local lsp_zero = require('lsp-zero')
require('lspconfig').intelephense.setup({})
local lspconfig = require('lspconfig')

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
  nmap('<leader>lse', vim.diagnostic.open_float, '[S]how [E]errors')

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

-- ensure_installed = { 'sorbet', 'rust_analyzer', 'elixirls', 'lua_ls', 'kotlin_language_server', 'jdtls' },

-- RUBY
local ruby_lsp_bin
if vim.env.GEM_HOME then
  ruby_lsp_bin = vim.fn.expand(vim.env.GEM_HOME .. "/bin/ruby-lsp")
else
  ruby_lsp_bin = ""
end

if ruby_lsp_bin ~= "" and vim.fn.executable(ruby_lsp_bin) == 0 then
  vim.notify("ruby-lsp not found, attempting to install...", vim.log.levels.INFO)
  vim.fn.jobstart("gem install ruby-lsp", {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Successfully installed ruby-lsp.", vim.log.levels.INFO)
      else
        vim.notify("Failed to install ruby-lsp.", vim.log.levels.ERROR)
      end
    end,
  })
end
-- Custom setup for ruby_lsp
lspconfig.ruby_lsp.setup({
  cmd = { ruby_lsp_bin }
})

lspconfig.sorbet.setup {
  cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
  root_dir = function(fname)
    local root = vim.lsp.util.root_pattern('sorbet/config')(fname)
    if root then
      return vim.fs.realpath(root)
    end
    return nil
  end,
}
-- END RUBY

-- JAVASCRIPT
-- if vim.fn.executable('typescript-language-server') == 0 then
--   vim.notify('typescript-language-server not found. Attemping to install...', vim.log.levels.INFO)
--   local install_command = 'npm install typescript-language-server typescript'
--   vim.fn.jobstart(install_command, {
--     on_exit = function(_, code)
--       if code == 0 then
--         vim.notify('Successfully installed typescript-language-server.', vim.log.levels.INFO)
--         -- You may need to restart Neovim for the new executable to be found.
--       else
--         vim.notify('Failed to install typescript-language-server. Please run `' .. install_command .. '` manually.',
--           vim.log.levels.ERROR)
--       end
--     end,
--   })
-- end

lspconfig.ts_ls.setup({
  init_options = { hostInfo = 'neovim' },
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  handlers = {
    -- handle rename request for certain code actions like extracting functions / types
    ['_typescript.rename'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = result.textDocument.uri,
        range = {
          start = result.position,
          ['end'] = result.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  }
})
-- END JAVASCRIPT

-- metals
lsp_zero.extend_lspconfig({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

local metals_config = require('metals').bare_config()
metals_config.capabilities = lsp_zero.get_capabilities()

local metals_augroup = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = metals_augroup,
  pattern = { 'scala', 'sbt', 'java' },
  callback = function()
    require('metals').initialize_or_attach(metals_config)
  end
})
