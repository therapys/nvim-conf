-- Gruvbox only: theme setup and plugin coloring

-- Detect macOS system theme
local function get_system_theme()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result:match("Dark") then
      return "dark"
    end
  end
  return "light"
end

local function apply_ui_highlights()
  local is_light = vim.o.background == "light"

  -- Get gruvbox colors based on background
  local colors
  if is_light then
    colors = {
      bg0 = "#f9f5d7",
      bg1 = "#f5edca",
      bg2 = "#f3eac7",
      bg3 = "#eee0b7",
      fg0 = "#654735",
      fg1 = "#4f3829",
      grey = "#928374",
      red = "#c14a4a",
      green = "#6c782e",
      yellow = "#b47109",
      blue = "#45707a",
      purple = "#945e80",
      aqua = "#4c7a5d",
      orange = "#c35e0a",
    }
  else
    colors = {
      bg0 = vim.g.terminal_color_0 or "#282828",
      bg1 = "#32302f",
      bg2 = "#45403d",
      bg3 = "#5a524c",
      fg0 = vim.g.terminal_color_7 or "#d4be98",
      fg1 = "#ddc7a1",
      grey = "#928374",
      red = vim.g.terminal_color_1 or "#ea6962",
      green = vim.g.terminal_color_2 or "#a9b665",
      yellow = vim.g.terminal_color_3 or "#d8a657",
      blue = vim.g.terminal_color_4 or "#7daea3",
      purple = vim.g.terminal_color_5 or "#d3869b",
      aqua = vim.g.terminal_color_6 or "#89b482",
      orange = "#e78a4e",
    }
  end

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
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Set gruvbox-material options before loading
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_invert_selection = 0  -- Disable selection inversion

      -- Follow system theme
      vim.o.background = get_system_theme()

      vim.cmd.colorscheme "gruvbox-material"
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
          theme = "gruvbox-material",
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

