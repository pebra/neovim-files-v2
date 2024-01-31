local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- local opts = {buffer = bufnr, remap = false}
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lrn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>lca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('<leader>lgd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('<leader>lgr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>lgI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
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

  -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  -- vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  -- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  -- vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'rust_analyzer', 'ruby_ls'},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})
-- -- LSP settings.
-- --  This function gets run when an LSP connects to a particular buffer.
-- local on_attach = function(_, bufnr)
--   -- NOTE: Remember that lua is a real programming language, and as such it is possible
--   -- to define small helper and utility functions so you don't have to repeat yourself
--   -- many times.
--   --
--   -- In this case, we create a function that lets us more easily define mappings specific
--   -- for LSP related items. It sets the mode, buffer and description for us each time.
--   local nmap = function(keys, func, desc)
--     if desc then
--       desc = 'LSP: ' .. desc
--     end
--
--     vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
--   end
--
--   nmap('<leader>lrn', vim.lsp.buf.rename, '[R]e[n]ame')
--   nmap('<leader>lca', vim.lsp.buf.code_action, '[C]ode [A]ction')
--
--   nmap('<leader>lgd', vim.lsp.buf.definition, '[G]oto [D]efinition')
--   nmap('<leader>lgr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--   nmap('<leader>lgI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
--   nmap('<leader>lgt', vim.lsp.buf.type_definition, 'Type [D]efinition')
--   nmap('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--   nmap('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
--   -- See `:help K` for why this keymap
--   nmap('<leader>lK', vim.lsp.buf.hover, 'Hover Documentation')
--   nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
--
--   nmap('<leader>lf', function()
--     vim.lsp.buf.format { async = true }
--   end)
--
--   -- Lesser used LSP functionality
--   nmap('<leader>lgD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--   nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
--   nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
--   nmap('<leader>lwl', function()
--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--   end, '[W]orkspace [L]ist Folders')
--
--   -- Create a command `:Format` local to the LSP buffer
--   vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--     vim.lsp.buf.format()
--   end, { desc = 'Format current buffer with LSP' })
-- end
--
-- -- Enable the following language servers
-- --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
-- --
-- --  Add any additional override configuration in the following tables. They will be passed to
-- --  the `settings` field of the server config. You must look up that documentation yourself.
-- local servers = {
--   tsserver = {},
--   rust_analyzer = {},
--   --  ruby_ls = {},
--   lua_ls = {
--     Lua = {
--       workspace = { checkThirdParty = false },
--       telemetry = { enable = false },
--     },
--   },
-- }
--
-- -- Setup neovim lua configuration
-- require('neodev').setup()
--
-- -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--
-- -- Ensure the servers above are installed
-- local mason_lspconfig = require 'mason-lspconfig'
--
-- mason_lspconfig.setup {
--   ensure_installed = vim.tbl_keys(servers),
-- }
--
-- require('lspconfig')['elixirls'].setup {
--   cmd = { "/home/pebra/bin/elixir-ls/language_server.sh" },
--   capabilities = capabilities,
--   on_attach = on_attach,
-- }
--
-- -- textDocument/diagnostic support until 0.10.0 is released
-- _timers = {}
-- local function setup_diagnostics(client, buffer)
--   if require("vim.lsp.diagnostic")._enable then
--     return
--   end
--
--   local diagnostic_handler = function()
--     local params = vim.lsp.util.make_text_document_params(buffer)
--     client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
--       if err then
--         local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
--         vim.lsp.log.error(err_msg)
--       end
--       local diagnostic_items = {}
--       if result then
--         diagnostic_items = result.items
--       end
--       vim.lsp.diagnostic.on_publish_diagnostics(
--         nil,
--         vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
--         { client_id = client.id }
--       )
--     end)
--   end
--
--   diagnostic_handler() -- to request diagnostics on buffer when first attaching
--
--   vim.api.nvim_buf_attach(buffer, false, {
--     on_lines = function()
--       if _timers[buffer] then
--         vim.fn.timer_stop(_timers[buffer])
--       end
--       _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
--     end,
--     on_detach = function()
--       if _timers[buffer] then
--         vim.fn.timer_stop(_timers[buffer])
--       end
--     end,
--   })
-- end
--
-- require("lspconfig").ruby_ls.setup({
--   on_attach = function(client, buffer)
--     setup_diagnostics(client, buffer)
--   end,
--   capabilities = capabilities,
-- })
--
-- mason_lspconfig.setup_handlers {
--   function(server_name)
--     require('lspconfig')[server_name].setup {
--       capabilities = capabilities,
--       on_attach = on_attach,
--       settings = servers[server_name],
--     }
--   end,
-- }
--
-- -- metals
-- local metals_config = require("metals").bare_config()
-- -- Example of settings
-- metals_config.settings = {
--   showImplicitArguments = true,
--   excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
-- }
-- -- *READ THIS*
-- -- I *highly* recommend setting statusBarProvider to true, however if you do,
-- -- you *have* to have a setting to display this in your statusline or else
-- -- you'll not see any messages from metals. There is more info in the help
-- -- docs about this
-- metals_config.init_options.statusBarProvider = "on"
--
-- -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
-- metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
-- require('lspconfig')['metals'].setup {
--   capabilities = metals_config.default_capabilities,
--   on_attach = on_attach,
--   settings = metals_config.settings,
-- }
--
-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
--

---
-- Create the configuration for metals
---
local metals_config = require('metals').bare_config()
metals_config.capabilities = lsp_zero.get_capabilities()

---
-- Autocmd that will actually be in charging of starting metals
---
local metals_augroup = vim.api.nvim_create_augroup('nvim-metals', {clear = true})
vim.api.nvim_create_autocmd('FileType', {
  group = metals_augroup,
  pattern = {'scala', 'sbt', 'java'},
  callback = function()
    require('metals').initialize_or_attach(metals_config)
  end
})
