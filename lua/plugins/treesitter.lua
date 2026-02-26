return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- Ensure parsers are installed (async, runs in background)
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
          require("nvim-treesitter").install({ "lua", "python", "bash", "json", "yaml", "markdown", "go", "gomod", "gowork", "gosum" })
        end,
      })

      -- Enable treesitter highlighting and indentation for supported filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Textobjects config
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local ts_select = require("nvim-treesitter-textobjects.select")
      local ts_move = require("nvim-treesitter-textobjects.move")

      -- Select textobjects
      for _, mode in ipairs({ "x", "o" }) do
        vim.keymap.set(mode, "af", function() ts_select.select_textobject("@function.outer") end)
        vim.keymap.set(mode, "if", function() ts_select.select_textobject("@function.inner") end)
        vim.keymap.set(mode, "ac", function() ts_select.select_textobject("@class.outer") end)
        vim.keymap.set(mode, "ic", function() ts_select.select_textobject("@class.inner") end)
      end

      -- Move to next/previous function/class
      vim.keymap.set({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function() ts_move.goto_next_start("@class.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function() ts_move.goto_previous_start("@class.outer") end)
    end,
  },
}
