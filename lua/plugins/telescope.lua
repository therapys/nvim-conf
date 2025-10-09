return {
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          pcall(function() require("telescope").load_extension("fzf") end)
        end,
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
          pcall(function() require("telescope").load_extension("ui-select") end)
        end,
      },
    },
    cmd = "Telescope",
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          mappings = { i = { ["<esc>"] = actions.close } },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
        },
      }
    end,
  },
}

