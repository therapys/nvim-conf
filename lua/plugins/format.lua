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
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { python = { "ruff" } }

      local grp = vim.api.nvim_create_augroup("UserNvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = grp,
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
}

