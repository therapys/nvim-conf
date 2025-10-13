return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { theme = "auto" } },
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
      { "gb", mode = { "n", "v" }, desc = "Toggle block comment" },
    },
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup()
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },
-- which-key (keymap hints)
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    -- optional: quiet the "mini.icons not installed" warning
    -- "echasnovski/mini.icons",
  },
  opts = {
    plugins = { spelling = true },
    win = { border = "rounded" }, -- was `window` (deprecated)
    layout = { align = "center" },
    icons = {
      -- if you don't want to pull mini.icons, it's fine to keep devicons
      mappings = false,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Use the NEW spec format for groups
    wk.add({
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>l", group = "lsp" },
      { "<leader>t", group = "telescope" },
      { "<leader>x", group = "trouble/diagnostics" },
      { "<leader>c", group = "code" },
    }, { mode = "n" })
  end,
},

  -- indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",   -- new module name
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<leader>tt]], -- toggle with <leader>tt
      start_in_insert = true,
      direction = "float",           -- or "horizontal"/"vertical"
      on_open = function(term)
        -- Map <Esc> to normal mode *inside* that terminal buffer
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
      end,
    },
  },
}

