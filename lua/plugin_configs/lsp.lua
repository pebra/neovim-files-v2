-- LSP settings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local bufnr = event.buf
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
  end,
})

-- RUBY
local ruby_lsp_bin
if vim.env.GEM_HOME then
  ruby_lsp_bin = vim.fn.expand(vim.env.GEM_HOME .. "/bin/ruby-lsp")
else
  ruby_lsp_bin = "ruby-lsp"
end

-- Only try to detect/install missing ruby-lsp in projects with a Gemfile.
if vim.fn.filereadable("Gemfile") == 1 and vim.fn.executable(ruby_lsp_bin) == 0 then
  vim.notify("ruby-lsp not found, attempting to install...", vim.log.levels.INFO)
  vim.fn.jobstart("gem install ruby-lsp ruby-lsp-rails", {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Successfully installed ruby-lsp.", vim.log.levels.INFO)
      else
        vim.notify("Failed to install ruby-lsp.", vim.log.levels.ERROR)
      end
    end,
  })
end

vim.lsp.config("ruby_lsp", {
  cmd = { ruby_lsp_bin },
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },
  init_options = {
    formatter = "auto",
    linters = { "auto" },
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
    enabledFeatures = {
      "documentSymbols",
      "documentHighlight",
      "foldingRanges",
      "selectionRanges",
      "semanticHighlighting",
      "diagnostics",
      "formatting",
      "codeActions",
      "inlayHints",
      "onTypeFormatting",
      "hover",
      "completion",
      "codeLens",
      "definition",
      "workspaceSymbol",
      "signatureHelp",
      "typeHierarchy",
    },
    experimentalFeaturesEnabled = true,
  },
})
vim.lsp.enable("ruby_lsp")
-- END RUBY

-- LUA
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
vim.lsp.enable("lua_ls")
-- END LUA
