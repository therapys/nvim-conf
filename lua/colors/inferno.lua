-- Inferno Colorscheme
-- Author: therapy

local M = {}

function M.setup()
  vim.opt.background = "dark"
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "inferno"

  local colors = {
    bg       = "#0d0d0d",
    fg       = "#e0d7c2",
    cursor   = "#ff6f2c",
    sel_bg   = "#3c2a24",
    sel_fg   = "#e0d7c2",
    comment  = "#6b6458",
    red      = "#ff3c1a",
    orange   = "#ff6f2c",
    yellow   = "#ffd36f",
    green    = "#8bc34a",
    cyan     = "#45c3c9",
    magenta  = "#e37aff",
    blue     = "#45c3c9",
    darkgray = "#3c2a24",
    lightgray= "#c0b8a4",
  }

  local hi = vim.api.nvim_set_hl

  -- Core
  hi(0, "Normal",        { fg = colors.fg, bg = colors.bg })
  hi(0, "Cursor",        { fg = colors.bg, bg = colors.cursor })
  hi(0, "Visual",        { fg = colors.sel_fg, bg = colors.sel_bg })
  hi(0, "LineNr",        { fg = colors.comment, bg = "NONE" })
  hi(0, "CursorLineNr",  { fg = colors.yellow, bg = "NONE" })
  hi(0, "StatusLine",    { fg = colors.fg, bg = colors.darkgray })
  hi(0, "VertSplit",     { fg = colors.darkgray, bg = "NONE" })
  hi(0, "Comment",       { fg = colors.comment, italic = true })
  hi(0, "Keyword",       { fg = colors.magenta, bold = true })
  hi(0, "Identifier",    { fg = colors.cyan })
  hi(0, "Function",      { fg = colors.orange, bold = true })
  hi(0, "String",        { fg = colors.yellow })
  hi(0, "Number",        { fg = colors.red })
  hi(0, "Type",          { fg = colors.green })
  hi(0, "Constant",      { fg = colors.red })
  hi(0, "Special",       { fg = colors.cyan })
  hi(0, "Error",         { fg = colors.red, bold = true })
  hi(0, "Pmenu",         { fg = colors.fg, bg = colors.darkgray })
  hi(0, "PmenuSel",      { fg = colors.bg, bg = colors.orange })
  hi(0, "Search",        { fg = colors.bg, bg = colors.orange })
  hi(0, "IncSearch",     { fg = colors.bg, bg = colors.magenta })
  hi(0, "CursorLine",    { bg = "#141414" })
  hi(0, "CursorColumn",  { bg = "#141414" })
  hi(0, "ColorColumn",   { bg = "#141414" })

  -- Diagnostic highlights
  hi(0, "DiagnosticError", { fg = colors.red })
  hi(0, "DiagnosticWarn",  { fg = colors.yellow })
  hi(0, "DiagnosticInfo",  { fg = colors.cyan })
  hi(0, "DiagnosticHint",  { fg = colors.green })

  -- Treesitter support
  hi(0, "@comment",        { link = "Comment" })
  hi(0, "@keyword",        { link = "Keyword" })
  hi(0, "@function",       { link = "Function" })
  hi(0, "@string",         { link = "String" })
  hi(0, "@number",         { link = "Number" })
  hi(0, "@type",           { link = "Type" })
  hi(0, "@constant",       { link = "Constant" })
  hi(0, "@variable",       { fg = colors.fg })
  hi(0, "@parameter",      { fg = colors.yellow })

  -- Neo-tree
  hi(0, "NeoTreeNormal",       { fg = colors.fg, bg = colors.bg })
  hi(0, "NeoTreeNormalNC",     { fg = colors.fg, bg = colors.bg })
  hi(0, "NeoTreeDirectoryIcon", { fg = colors.orange })
  hi(0, "NeoTreeDirectoryName", { fg = colors.cyan })
  hi(0, "NeoTreeFileName",     { fg = colors.fg })
  hi(0, "NeoTreeFileNameOpened", { fg = colors.orange })
  hi(0, "NeoTreeGitAdded",     { fg = colors.green })
  hi(0, "NeoTreeGitModified",  { fg = colors.yellow })
  hi(0, "NeoTreeGitDeleted",   { fg = colors.red })
  hi(0, "NeoTreeRootName",     { fg = colors.magenta, bold = true })
  hi(0, "NeoTreeIndentMarker", { fg = colors.darkgray })

end

return M

