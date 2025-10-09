return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle left<cr>", desc = "Explorer (neo-tree)" },
      { "<leader>E", "<cmd>Neotree reveal left<cr>", desc = "Reveal current file" },
    },
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      sources = { "filesystem", "buffers", "git_status" },
      window = { position = "left", width = 30 },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_default",
        filtered_items = { hide_dotfiles = false, hide_gitignored = true },
      },
    },
  },
}
