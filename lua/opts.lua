-- Sensible core options (adjust to taste)
local opt = vim.opt

opt.number = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.signcolumn = "yes"
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 4
opt.wrap = false
opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Python-specific indentation (PEP 8 = 4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- Auto-close quickfix / location list after jumping to an entry
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", function()
      local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
      local is_loclist = (wininfo and wininfo.loclist == 1)

      if is_loclist then
        vim.cmd("ll")   -- open current location-list entry
      else
        vim.cmd("cc")   -- open current quickfix entry
      end

      -- close after the jump finishes
      vim.schedule(function()
        if is_loclist then vim.cmd("lclose") else vim.cmd("cclose") end
      end)
    end, { buffer = true, silent = true })
  end,
})

