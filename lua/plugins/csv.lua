local function field_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".") - 1
  local delim = vim.bo.filetype == "tsv" and "\t" or ","

  local fields, starts, ends = {}, {}, {}
  local buf, field_start, in_quotes = {}, 1, false
  for i = 1, #line do
    local c = line:sub(i, i)
    if c == '"' then
      in_quotes = not in_quotes
      buf[#buf + 1] = c
    elseif c == delim and not in_quotes then
      fields[#fields + 1] = table.concat(buf)
      starts[#starts + 1] = field_start - 1
      ends[#ends + 1] = i - 1
      buf, field_start = {}, i + 1
    else
      buf[#buf + 1] = c
    end
  end
  fields[#fields + 1] = table.concat(buf)
  starts[#starts + 1] = field_start - 1
  ends[#ends + 1] = #line

  for idx = 1, #fields do
    if col >= starts[idx] and col <= ends[idx] then
      return fields[idx], idx
    end
  end
  return fields[#fields], #fields
end

local function preview_field()
  local value, idx = field_at_cursor()
  if value:sub(1, 1) == '"' and value:sub(-1) == '"' then
    value = value:sub(2, -2):gsub('""', '"')
  end

  local width = math.min(80, math.floor(vim.o.columns * 0.6))
  local lines = {}
  for paragraph in (value .. "\n"):gmatch("([^\n]*)\n") do
    if paragraph == "" then
      lines[#lines + 1] = ""
    else
      while #paragraph > width do
        local cut = paragraph:sub(1, width):find("%s[^%s]*$") or width
        lines[#lines + 1] = paragraph:sub(1, cut)
        paragraph = paragraph:sub(cut + 1)
      end
      lines[#lines + 1] = paragraph
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local height = math.min(#lines, math.floor(vim.o.lines * 0.5))
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width,
    height = math.max(1, height),
    style = "minimal",
    border = "rounded",
    title = " field " .. idx .. " ",
    title_pos = "left",
  })
  vim.wo[win].wrap = true
  vim.wo[win].linebreak = true

  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end,
  })
end

return {
  {
    "hat0uma/csvview.nvim",
    ft = { "csv", "tsv" },
    opts = {
      parser = { comments = { "#", "//" } },
      view = {
        display_mode = "border",
        sticky_header = { enabled = true },
      },
      keymaps = {
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<CR>", mode = { "n", "v" } },
        jump_prev_row = { "<S-CR>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    config = function(_, opts)
      require("csvview").setup(opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv", "tsv" },
        callback = function()
          vim.cmd("CsvViewEnable")
          vim.keymap.set("n", "K", preview_field, { buffer = true, desc = "Preview CSV field" })
        end,
      })
    end,
  },
  {
    "cameron-wags/rainbow_csv.nvim",
    ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe", "rfc_csv", "rfc_semicolon" },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
      "RainbowNoDelim",
    },
    config = true,
  },
}
