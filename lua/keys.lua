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
-- Diagnostics (use Trouble if available, fallback to native)
-- ======================
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic: Previous" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic: Next" })

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

-- ======================
-- Amp keybinds
-- ======================
map("v", "<leader>ap", "<cmd>AmpPromptSelection<CR>", { desc = "Amp: Add selection to prompt" })
map("v", "<leader>ar", "<cmd>AmpPromptRef<CR>", { desc = "Amp: Add file ref to prompt" })
map("n", "<leader>ar", "<cmd>AmpPromptRef<CR>", { desc = "Amp: Add file ref to prompt" })

-- Send a quick message to the agent
vim.api.nvim_create_user_command("AmpSend", function(opts)
  local message = opts.args
  if message == "" then
    print("Please provide a message to send")
    return
  end

  local amp_message = require("amp.message")
  amp_message.send_message(message)
end, {
  nargs = "*",
  desc = "Send a message to Amp",
})

-- Send entire buffer contents
vim.api.nvim_create_user_command("AmpSendBuffer", function(opts)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local content = table.concat(lines, "\n")

  local amp_message = require("amp.message")
  amp_message.send_message(content)
end, {
  nargs = "?",
  desc = "Send current buffer contents to Amp",
})

-- Add selected text directly to prompt
vim.api.nvim_create_user_command("AmpPromptSelection", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  local text = table.concat(lines, "\n")

  local amp_message = require("amp.message")
  amp_message.send_to_prompt(text)
end, {
  range = true,
  desc = "Add selected text to Amp prompt",
})

-- Add file+selection reference to prompt
vim.api.nvim_create_user_command("AmpPromptRef", function(opts)
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    print("Current buffer has no filename")
    return
  end

  local relative_path = vim.fn.fnamemodify(bufname, ":.")
  local ref = "@" .. relative_path
  if opts.line1 ~= opts.line2 then
    ref = ref .. "#L" .. opts.line1 .. "-" .. opts.line2
  elseif opts.line1 > 1 then
    ref = ref .. "#L" .. opts.line1
  end

  local amp_message = require("amp.message")
  amp_message.send_to_prompt(ref)
end, {
  range = true,
  desc = "Add file reference (with selection) to Amp prompt",
})