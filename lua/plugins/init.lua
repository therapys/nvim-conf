 -- lua/plugins/init.lua
return {
  { import = "plugins.core" },        -- lazy itself, plenary, devicons, surround, yanky
  { import = "plugins.telescope" },
  { import = "plugins.treesitter" },
  { import = "plugins.lsp" },         -- mason, mason-lspconfig, lsp (new API)
  { import = "plugins.completion" },  -- cmp, luasnip, lspkind, snippets
  { import = "plugins.format" },      -- conform, nvim-lint
  { import = "plugins.ui" },          -- lualine, comment, autopairs, gitsigns, which-key, indent-blankline
  { import = "plugins.files" },       -- neo-tree (left)
  { import = "plugins.colors" },      -- gruvbox, ccc, lualine config
  { import = "plugins.agent" },       -- amp.nvim
  { import = "plugins.golang"},       -- go.nvim
  { import = "plugins.trouble"},      -- trouble, todo-comments
  { import = "plugins.tmux"},         -- tmux navigator
  { import = "plugins.multicursor"},  -- vim-visual-multi
  { import = "plugins.git"},          -- fugitive, diffview, git-conflict
  { import = "plugins.markdown"},     -- markdown plugins (if needed)
  { import = "plugins.snacks"},       -- snacks.nvim (dashboard, zen, terminal, etc)
  { import = "plugins.claude"},       -- claudecode.nvim
  { import = "plugins.motion"},       -- flash.nvim
  { import = "plugins.search"},       -- spectre
  { import = "plugins.session"},      -- persistence
  { import = "plugins.undo"},         -- undotree
  { import = "plugins.bufferline"},   -- bufferline
  { import = "plugins.csv"},          -- csv.vim
}

