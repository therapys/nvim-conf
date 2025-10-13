return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    config = function()
      require("go").setup({
        disable_defaults = false,
        go = "go",
        goimports = "gopls",
        fillstruct = "gopls",
        gofmt = "gofumpt",
        lsp_cfg = false,
        lsp_gofumpt = true,
        lsp_on_attach = false,
        dap_debug = false,
        dap_debug_gui = false,
      })
    end,
  },
}