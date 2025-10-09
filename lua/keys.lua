local map = vim.keymap.set

-- ======================
-- Telescope (with safe fallback)
-- ======================
do
  local ok, tb = pcall(require, "telescope.builtin")
  if ok then
    map("n", "<leader>ff", tb.find_files, { desc = "Telescope: Find files" })
    map("n", "<leader>fg", tb.live_grep,  { desc = "Telescope: Live grep" })
    map("n", "<leader>fb", tb.buffers,    { desc = "Telescope: Buffers" })
    map("n", "<leader>fh", tb.help_tags,  { desc = "Telescope: Help tags" })
  else
    map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope: Find files" })
    map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "Telescope: Live grep" })
    map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Telescope: Buffers" })
    map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",  { desc = "Telescope: Help tags" })
  end
end

-- Grep word under cursor (safe if Telescope not loaded)
map("n", "<leader>fw", function()
  local ok, tb = pcall(require, "telescope.builtin")
  if ok then
    tb.live_grep({ default_text = vim.fn.expand("<cword>") })
  else
    vim.cmd("Telescope live_grep")
  end
end, { desc = "Telescope: Grep word under cursor" })

-- Grep visual selection
map("v", "<leader>fg", function()
  local _, csrow, cscol = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol = unpack(vim.fn.getpos("'>"))
  local text
  if csrow == cerow then
    text = string.sub(vim.fn.getline(csrow), cscol, cecol)
  else
    local lines = vim.fn.getline(csrow, cerow)
    lines[1] = string.sub(lines[1], cscol)
    lines[#lines] = string.sub(lines[#lines], 1, cecol)
    text = table.concat(lines, "\n")
  end
  local ok, tb = pcall(require, "telescope.builtin")
  if ok then
    tb.live_grep({ default_text = text })
  else
    vim.cmd("Telescope live_grep")
  end
end, { desc = "Telescope: Grep visual selection" })

-- ======================
-- Diagnostics
-- ======================
map("n", "[d", vim.diagnostic.goto_prev,         { desc = "Diagnostic: Previous" })
map("n", "]d", vim.diagnostic.goto_next,         { desc = "Diagnostic: Next" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics → loclist" })
map("n", "<leader>lo", "<cmd>lopen<CR>",         { desc = "Location list: Open" })
map("n", "<leader>lc", "<cmd>lclose<CR>",        { desc = "Location list: Close" })
map("n", "<leader>ln", "<cmd>lnext<CR>",         { desc = "Location list: Next" })
map("n", "<leader>lp", "<cmd>lprev<CR>",         { desc = "Location list: Prev" })

-- ======================
-- Tabs
-- ======================
map("n", "<leader>tn", "<cmd>tabnew<CR>",       { desc = "Tab: New" })
map("n", "<leader>tc", "<cmd>tabclose<CR>",     { desc = "Tab: Close" })
map("n", "<leader>to", "<cmd>tabonly<CR>",      { desc = "Tab: Close others" })
map("n", "<leader>tl", "<cmd>tabnext<CR>",      { desc = "Tab: Next" })
map("n", "<leader>th", "<cmd>tabprevious<CR>",  { desc = "Tab: Previous" })

-- ======================
-- LSP helpers & motions (with Telescope fallbacks)
-- ======================
local function lsp_attached()
  return vim.lsp and vim.lsp.get_clients and #vim.lsp.get_clients({ bufnr = 0 }) > 0
end

local function supports(cap)
  for _, c in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if c.server_capabilities and c.server_capabilities[cap] then return true end
  end
  return false
end

-- gi: implementations (fallback to references/definition if unsupported)
map("n", "gi", function()
  if not lsp_attached() then return vim.cmd.normal("gi") end
  local ok, tb = pcall(require, "telescope.builtin")
  if supports("implementationProvider") then
    if ok then tb.lsp_implementations() else vim.lsp.buf.implementation() end
  else
    if ok then tb.lsp_references({ include_declaration = false }) else vim.lsp.buf.definition() end
  end
end, { desc = "LSP: Implementations (smart fallback)" })

-- gd: definition
map("n", "gd", function()
  if not lsp_attached() then return vim.cmd.normal("gd") end
  local ok, tb = pcall(require, "telescope.builtin")
  if ok then tb.lsp_definitions() else vim.lsp.buf.definition() end
end, { desc = "LSP: Definitions" })

-- gD: declaration  (conventional)
map("n", "gD", function()
  if not lsp_attached() then return vim.cmd.normal("gD") end
  vim.lsp.buf.declaration()
end, { desc = "LSP: Declaration" })

-- gT: type definition
map("n", "gT", function()
  if not lsp_attached() then return end
  local ok, tb = pcall(require, "telescope.builtin")
  if ok then tb.lsp_type_definitions() else vim.lsp.buf.type_definition() end
end, { desc = "LSP: Type definition" })

-- gr: references
map("n", "gr", function()
  if not lsp_attached() then return end
  local ok, tb = pcall(require, "telescope.builtin")
  if ok then tb.lsp_references() else vim.lsp.buf.references() end
end, { desc = "LSP: References" })

map("n", "<leader>ts", "<cmd>split | terminal<CR>", { desc = "Terminal split" })
map("n", "<leader>tv", "<cmd>vsplit | terminal<CR>", { desc = "Terminal vsplit" })

