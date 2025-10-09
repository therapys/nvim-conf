 -- lua/plugins/init.lua
return {
  { import = "plugins.core" },        -- lazy itself, plenary, devicons, basics
  { import = "plugins.telescope" },
  { import = "plugins.treesitter" },
  { import = "plugins.lsp" },         -- mason, mason-lspconfig, lsp (new API)
  { import = "plugins.completion" },  -- cmp, luasnip, lspkind, snippets
  { import = "plugins.format" },      -- conform, nvim-lint
  { import = "plugins.ui" },          -- lualine, comment, autopairs, gitsigns
  { import = "plugins.files" },       -- neo-tree (left)
  { import = "plugins.outline" },     -- outline.nvim (right)
  { import = "plugins.colors" },      -- onedark
}

