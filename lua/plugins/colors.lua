-- Gruvbox Material only: theme setup and plugin coloring

local function get_gruvbox_material_palette()
  local ok, palette = pcall(
    vim.fn["gruvbox_material#get_palette"],
    vim.g.gruvbox_material_background,
    vim.g.gruvbox_material_foreground,
    vim.g.gruvbox_material_colors_override or {}
  )
  if not ok then
    return nil
  end

  local function hex(name)
    return palette[name] and palette[name][1] or nil
  end

  return {
    bg0 = hex "bg0",
    bg1 = hex "bg1",
    bg2 = hex "bg2",
    bg3 = hex "bg3",
    bg_statusline1 = hex "bg_statusline1",
    bg_statusline2 = hex "bg_statusline2",
    bg_statusline3 = hex "bg_statusline3",
    bg_diff_green = hex "bg_diff_green",
    bg_diff_red = hex "bg_diff_red",
    bg_diff_blue = hex "bg_diff_blue",
    fg0 = hex "fg0",
    fg1 = hex "fg1",
    fg2 = hex "fg2",
    fg3 = hex "fg3",
    fg4 = hex "fg4",
    red = hex "red",
    orange = hex "orange",
    yellow = hex "yellow",
    green = hex "green",
    aqua = hex "aqua",
    blue = hex "blue",
    purple = hex "purple",
    grey0 = hex "grey0",
    grey1 = hex "grey1",
    grey2 = hex "grey2",
  }
end

-- Diffview readability tuned for Gruvbox Material palette
local function apply_diffview_highlights(palette)
  if not palette then
    return
  end

  local set = vim.api.nvim_set_hl
  set(0, "DiffAdd", { bg = palette.bg_diff_green or palette.bg3, fg = palette.green })
  set(0, "DiffChange", { bg = palette.bg_diff_blue or palette.bg2, fg = palette.blue })
  set(0, "DiffDelete", { bg = palette.bg_diff_red or palette.bg2, fg = palette.red })
  set(0, "DiffText", { bg = palette.bg3, fg = palette.orange or palette.yellow, bold = true })

  set(0, "DiffviewNormal", { bg = palette.bg0, fg = palette.fg1 })
  set(0, "DiffviewCursorLine", { bg = palette.bg1 })
  set(0, "DiffviewFilePanelTitle", { fg = palette.orange or palette.yellow, bold = true })
  set(0, "DiffviewFilePanelCounter", { fg = palette.orange or palette.yellow })
  set(0, "DiffviewFilePanelFileName", { fg = palette.fg1 })
  set(0, "DiffviewStatusAdded", { fg = palette.green })
  set(0, "DiffviewStatusModified", { fg = palette.blue })
  set(0, "DiffviewStatusDeleted", { fg = palette.red })
  set(0, "DiffviewStatusRenamed", { fg = palette.orange or palette.yellow })
end

local function apply_ui_highlights(palette)
  if not palette then
    return
  end

  local set = vim.api.nvim_set_hl
  set(0, "EdgyWinBar", { bg = palette.bg0 })
  set(0, "EdgyNormal", { bg = palette.bg0 })
  set(0, "LspInlayHint", { bg = palette.bg1, fg = palette.grey1 })
  set(0, "WinSeparator", { bg = palette.bg0, fg = palette.bg2 })
  set(0, "TreesitterContextBottom", { sp = palette.bg2, underline = false })
  set(0, "TreesitterContextLineNumberBottom", { sp = palette.bg2, underline = false })
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
    init = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
    end,
    config = function()
      vim.cmd.colorscheme "gruvbox-material"

      local palette = get_gruvbox_material_palette()
      apply_diffview_highlights(palette)
      apply_ui_highlights(palette)
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

