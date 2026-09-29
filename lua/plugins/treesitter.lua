return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function(plugin)
      -- Add runtime/ subdir to rtp so query files (highlights, etc.) are found
      vim.opt.rtp:append(plugin.dir .. "/runtime")

      -- Ensure parsers are installed (async, runs in background)
      local ensure_installed = {
        "lua", "python", "bash", "json", "yaml", "javascript", "html",
        "markdown", "markdown_inline", "latex",
        "go", "gomod", "gowork", "gosum", "swift",
      }
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
          require("nvim-treesitter").install(ensure_installed)
        end,
      })

      -- Enable treesitter highlighting and indentation for supported filetypes
      local function try_enable_ts(buf)
        if pcall(vim.treesitter.start, buf) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev) try_enable_ts(ev.buf) end,
      })

      -- Enable for buffers already loaded before this plugin (FileType fired before BufReadPost)
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
          try_enable_ts(buf)
        end
      end

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
