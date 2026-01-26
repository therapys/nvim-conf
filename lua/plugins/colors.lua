-- Gruvbox only: theme setup and plugin coloring

local function apply_ui_highlights()
  -- Get gruvbox colors
  local colors = {
    bg0 = vim.g.terminal_color_0 or "#282828",
    bg1 = "#3c3836",
    bg2 = "#504945",
    bg3 = "#665c54",
    fg0 = vim.g.terminal_color_7 or "#ebdbb2",
    fg1 = "#ebdbb2",
    grey = "#928374",
    red = vim.g.terminal_color_1 or "#fb4934",
    green = vim.g.terminal_color_2 or "#b8bb26",
    yellow = vim.g.terminal_color_3 or "#fabd2f",
    blue = vim.g.terminal_color_4 or "#83a598",
    purple = vim.g.terminal_color_5 or "#d3869b",
    aqua = vim.g.terminal_color_6 or "#8ec07c",
    orange = "#fe8019",
  }

  local set = vim.api.nvim_set_hl

  -- Fix Visual mode selection - force it to override syntax highlighting
  set(0, "Visual", { bg = colors.bg3, reverse = false })
  set(0, "VisualNOS", { bg = colors.bg3 })

  -- Force operators to not override visual selection
  set(0, "Operator", { fg = colors.fg1, bg = "NONE" })
  set(0, "@operator", { fg = colors.fg1, bg = "NONE" })
  set(0, "@punctuation.special", { fg = colors.fg1, bg = "NONE" })

  -- Ensure visual selection overrides operator highlighting
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "Visual", { bg = colors.bg3, reverse = false })
      vim.api.nvim_set_hl(0, "Operator", { fg = colors.fg1, bg = "NONE" })
      vim.api.nvim_set_hl(0, "@operator", { fg = colors.fg1, bg = "NONE" })
    end,
  })

  -- Base UI
  set(0, "EdgyWinBar", { bg = colors.bg0 })
  set(0, "EdgyNormal", { bg = colors.bg0 })
  set(0, "LspInlayHint", { bg = colors.bg1, fg = colors.grey })
  set(0, "WinSeparator", { bg = colors.bg0, fg = colors.bg2 })

  -- Flash.nvim (motion plugin)
  set(0, "FlashLabel", { fg = colors.bg0, bg = colors.red, bold = true })
  set(0, "FlashMatch", { fg = colors.fg0, bg = colors.bg2 })
  set(0, "FlashCurrent", { fg = colors.bg0, bg = colors.orange, bold = true })

  -- Diffview
  set(0, "DiffviewFilePanelTitle", { fg = colors.blue, bold = true })
  set(0, "DiffviewFilePanelCounter", { fg = colors.purple })
  set(0, "DiffviewFilePanelFileName", { fg = colors.fg1 })
  set(0, "DiffviewNormal", { bg = colors.bg0 })
  set(0, "DiffviewCursorLine", { bg = colors.bg1 })
  set(0, "DiffviewStatusLine", { bg = colors.bg1 })
  set(0, "DiffviewVertSplit", { fg = colors.bg2 })

  -- Spectre (search/replace)
  set(0, "SpectreSearch", { fg = colors.red, bg = colors.bg1 })
  set(0, "SpectreReplace", { fg = colors.green, bg = colors.bg1 })
  set(0, "SpectreFile", { fg = colors.blue })
  set(0, "SpectreDir", { fg = colors.aqua })
  set(0, "SpectreLineNum", { fg = colors.grey })

  -- Yanky (yank history)
  set(0, "YankyYanked", { link = "IncSearch" })
  set(0, "YankyPut", { link = "IncSearch" })

  -- Mini.surround
  set(0, "MiniSurround", { link = "IncSearch" })
end

return {
  {
    "uga-rosa/ccc.nvim",
    keys = {
      { mode = "n", "<leader>cc", "<cmd>CccPick<cr>" },
    },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = false,
      },
    },
  },

  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      -- Set gruvbox options before loading
      vim.g.gruvbox_italic = 1
      vim.g.gruvbox_bold = 1
      vim.g.gruvbox_invert_selection = 0  -- Disable selection inversion

      vim.cmd.colorscheme "gruvbox"
      apply_ui_highlights()
    end,
  },

  {
    priority = 1000,
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "linrongbin16/lsp-progress.nvim",
        opts = {
          format = function(client_messages)
            local api = require "lsp-progress.api"
            local lsp_clients = #api.lsp_clients()
            if #client_messages > 0 then
              return table.concat(client_messages, " ")
            elseif lsp_clients > 0 then
              return "󰄳 LSP " .. lsp_clients .. " clients"
            end
            return ""
          end,
        },
      },
    },
    cond = function()
      return os.getenv "PRESENTATION" ~= "true"
    end,
    config = function()
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })

      require("lualine").setup {
        options = {
          disabled_filetypes = {
            statusline = { "alpha", "NvimTree", "trouble", "Outline" },
          },
          theme = "gruvbox",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                local mode_map = {
                  ["NORMAL"] = "NR",
                  ["INSERT"] = "IN",
                  ["VISUAL"] = "VV",
                  ["V-LINE"] = "VL",
                  ["V-BLOCK"] = "VB",
                  ["REPLACE"] = "RP",
                  ["COMMAND"] = "CM",
                  ["TERMINAL"] = "TR",
                  ["SELECT"] = "SL",
                }
                return mode_map[str] or str:sub(1, 1)
              end,
            },
          },
          lualine_c = {
            function()
              return require("lsp-progress").progress()
            end,
          },
          lualine_x = { "filetype" },
          lualine_y = {},
          lualine_z = { { "os.date('󰅐 %H:%M')" } },
        },
      }
    end,
  },
}

