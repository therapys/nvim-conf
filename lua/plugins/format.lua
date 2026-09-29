return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufReadPost" },
    keys = {
      { "<leader>f", function() require("conform").format() end, desc = "Format" },
    },
    opts = {
      formatters_by_ft = {
        python = { "black" },
        go = { "goimports", "gofmt" },
        json = { "jq" },
        yaml = { "yamlfmt" },
        ["yaml.docker-compose"] = { "prettier" },
        swift = { "swift_format" },
      },
      formatters = {
        -- Apple's swift-format ships with the Xcode toolchain but isn't on the
        -- plain PATH, so drive it via the `swift format -` subcommand (stdin).
        swift_format = {
          command = "swift",
          args = { "format", "-" },
          stdin = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" },
      }
      
      -- Only add ruff if it's available
      if vim.fn.executable("ruff") == 1 then
        lint.linters_by_ft.python = { "ruff" }
      end
      
      -- Only add hadolint if it's available
      if vim.fn.executable("hadolint") == 1 then
        lint.linters_by_ft.dockerfile = { "hadolint" }
      end

      local grp = vim.api.nvim_create_augroup("UserNvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = grp,
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
}
