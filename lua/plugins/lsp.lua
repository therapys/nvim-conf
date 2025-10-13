-- lua/plugins/lsp.lua
return {
  -- Mason (manages external LSP/DAP/formatters)
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "goimports",
        "gofumpt",
        "golangci-lint",
        "hadolint",
        "prettier",
        "yamlfmt",
        "jq",
      },
    },
  },

  -- Mason bridge to ensure LSP servers are installed
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "pyright", "lua_ls", "vtsls", "jsonls", "yamlls", "bashls",
        "html", "cssls", "marksman", "dockerls", "docker_compose_language_service",
        "clangd", "cmake", "gopls",
      },
      automatic_installation = false,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },

  -- Core LSP setup (using the new vim.lsp.config / enable APIs)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "b0o/schemastore.nvim",
    },
    config = function()
      -- Base capabilities (augmented by nvim-cmp if present)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- IMPORTANT: unify offset encoding across ALL servers
      -- Choose one and stick to it everywhere. We'll pick UTF-16 and force clangd to match.
      capabilities.offsetEncoding = { "utf-16" }

      -- Optional: keymaps etc.
      local function on_attach(client, _bufnr)
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = _bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            buffer = _bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Server-specific configs
      local servers = {
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        vtsls = {},
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
              format = { enable = true },
              validate = true,
              hover = true,
              completion = true,
            },
          },
        },
        bashls = {},
        html = {},
        cssls = {},
        marksman = {},
        dockerls = {},
        docker_compose_language_service = {},
        -- Force clangd to use the same offset encoding as our capabilities
        clangd = {
          cmd = { "clangd", "--offset-encoding=utf-16" },
        },
        cmake = {},
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        -- If you add eslint later, keep it aligned:
        -- eslint = {},
      }

      -- Register configs and enable servers
      for name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        cfg.on_attach = on_attach
        vim.lsp.config(name, cfg)  -- define how to start this server
        vim.lsp.enable(name)       -- enable it globally for its filetypes
      end

      -- (Optional) Tiny probe to confirm who attaches & with what encoding
      -- Uncomment if you want to verify:
      -- vim.api.nvim_create_autocmd("LspAttach", {
      --   callback = function(args)
      --     local client = vim.lsp.get_client_by_id(args.data.client_id)
      --     if client then
      --       vim.schedule(function()
      --         vim.notify(string.format("[LSP] %s (offset=%s)", client.name, client.offset_encoding or "unknown"))
      --       end)
      --     end
      --   end,
      -- })
    end,
  },
}
