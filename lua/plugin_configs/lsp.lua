-- LSP settings

-- Advertise nvim-cmp's capabilities to every language server so that
-- completion, snippets and resolve support are enabled everywhere.
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  vim.lsp.config("*", { capabilities = cmp_nvim_lsp.default_capabilities() })
end

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
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ async = true, lsp_format = "fallback" })
      else
        vim.lsp.buf.format { async = true }
      end
    end, '[F]ormat')

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

-- KOTLIN
-- Prefer the official JetBrains language server (`intellij-server`, shipped by
-- the `kotlin-lsp` package). See https://github.com/Kotlin/kotlin-lsp
local kotlin_lsp_cmd = { "kotlin-lsp", "--stdio" }
if vim.fn.executable("intellij-server") == 1 then
  kotlin_lsp_cmd = { "intellij-server", "--stdio" }
end

local kotlin_root_markers = {
  "settings.gradle", -- Gradle (multi-project)
  "settings.gradle.kts",
  "build.gradle",
  "build.gradle.kts",
  "pom.xml",
  ".git",
}

vim.lsp.config("kotlin_lsp", {
  cmd = kotlin_lsp_cmd,
  filetypes = { "kotlin" },
  root_markers = kotlin_root_markers,
  -- The official server is project-scoped and does not support single files.
  single_file_support = false,
})
vim.lsp.enable("kotlin_lsp")

-- Optional fallback: the community `kotlin-language-server` (fwcd). Enable this
-- instead if you prefer a lighter, fully open-source server.
-- vim.lsp.config("kotlin_language_server", {
--   cmd = { "kotlin-language-server" },
--   filetypes = { "kotlin" },
--   root_markers = kotlin_root_markers,
--   init_options = { storagePath = vim.fn.stdpath("cache") .. "/kotlin-language-server" },
-- })
-- vim.lsp.enable("kotlin_language_server")
-- END KOTLIN
