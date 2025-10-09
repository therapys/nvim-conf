return {
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<cr>", desc = "Symbols outline" },
    },
    opts = {
      outline_window = { position = "right", width = 35 },
      providers = { priority = { "lsp", "treesitter", "markdown" } },
      symbol_folding = { auto_unfold = { hovered = true } },
    },
  },
}

