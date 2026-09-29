# Neovim Configuration Cheatsheet

## Leader Key
`<leader>` = `Space`

---

## 📁 File Navigation

### Telescope (`<leader>f`)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fG` - Live grep with args (use `<C-k>` to quote, `<C-i>` for --iglob)
- `<leader>fb` - Buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Recent files
- `<leader>fc` - Commands
- `<leader>fk` - Keymaps
- `<leader>fs` - Document symbols
- `<leader>fS` - Workspace symbols
- `<leader>fd` - Diagnostics
- `<leader>fp` - File browser
- `<leader>fw` - Grep word under cursor
- `<leader>fg` (visual) - Grep selection

**Telescope Navigation:**
- `<C-j/k>` - Next/Previous
- `<C-q>` - Send to quickfix
- `<C-s>` - Horizontal split
- `<Esc>` - Close

### Neo-tree
- `<leader>e` - Toggle file explorer
- `<leader>E` - Reveal current file

---

## 🔧 LSP

### Navigation
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gT` - Go to type definition
- `gr` - Find references
- `K` - Hover documentation

### Diagnostics
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

---

## 🚨 Trouble & Diagnostics

- `<leader>q` - All diagnostics
- `<leader>Q` - Buffer diagnostics
- `<leader>o` - Code symbols outline
- `<leader>cl` - LSP definitions/references
- `<leader>xL` - Location list
- `<leader>xQ` - Quickfix list
- `[q` / `]q` - Previous/Next trouble item

---

## 📝 TODO Comments

- `]t` / `[t` - Next/Previous TODO
- `<leader>xt` - All TODOs (Trouble)
- `<leader>xT` - TODO/FIX/FIXME only
- `<leader>ft` - Find TODOs (Telescope)

**Keywords:** `TODO:`, `FIX:`, `FIXME:`, `HACK:`, `WARN:`, `PERF:`, `NOTE:`, `TEST:`

---

## ✏️ Code Editing

### Multi-Cursor (vim-visual-multi)
- `<C-n>` - Select word, repeat for next occurrence
- `<C-S-n>` - Select all occurrences
- `<C-Down/Up>` - Add cursor below/above
- `<C-x>` - Skip region
- `<C-p>` - Remove region
- `q` - Skip and find next (in VM mode)

### Comments
- `gcc` - Toggle line comment
- `gc` (visual) - Toggle comment
- `gb` - Toggle block comment

### Autopairs
- Auto-closes `()`, `[]`, `{}`, `''`, `""`

### Formatting
- `<leader>f` - Format current file

---

## 📖 Markdown

Markdown files get inline rendering, Markdown-aware editing, wrapped display, and an optional browser preview.

### Reading
- `<leader>mr` - Toggle rendered/raw Markdown in the current buffer
- `<leader>ms` - Open/close an in-Neovim side preview
- `<leader>mp` - Toggle browser preview (renders Mermaid and KaTeX)
- `<leader>md` - Open the Mermaid diagram under the cursor in its own tab
- `]h` / `[h` - Next/previous heading
- `gf` - Follow the link under the cursor
- `<leader>z` - Toggle distraction-free Zen mode

### Editing
- `<leader>mx` - Toggle checkbox (normal or visual mode)
- `<leader>ml` - Create a link from the word/selection
- `<leader>my` - Create a link using the clipboard as its URL
- `<leader>mt` - Format the table under the cursor
- `<leader>mn` - Renumber the current ordered list

Inline rendering is active in normal mode and reveals Markdown source while inserting.
Mermaid code blocks render automatically as images after leaving insert mode.
Marksman supplies document symbols, link completion, and link diagnostics.

---

## 🐹 Go-specific (go.nvim)

Auto-loaded on `.go` files:
- `:GoRun` - Run current file
- `:GoTest` - Run tests
- `:GoTestFunc` - Test function under cursor
- `:GoCoverage` - Show coverage
- `:GoFillStruct` - Fill struct fields
- `:GoIfErr` - Add if err != nil

---

## 🎨 Treesitter

### Text Objects
- `af` / `if` - Around/Inside function
- `ac` / `ic` - Around/Inside class

### Navigation
- `]f` / `[f` - Next/Previous function
- `]c` / `[c` - Next/Previous class

### Selection
- `<C-space>` - Init/expand selection
- `<BS>` - Shrink selection

---

## 🪟 Window/Tab Management

### Tabs
- `<leader>tn` - New tab
- `<leader>tc` - Close tab
- `<leader>to` - Close other tabs
- `<leader>tl` - Next tab
- `<leader>th` - Previous tab

### Terminal
- `<leader>tt` - Toggle floating terminal
- `<leader>ts` - Terminal split
- `<leader>tv` - Terminal vsplit
- `<Esc>` (in terminal) - Exit insert mode

---

## 🤖 Amp (AI Agent)

- `<leader>ap` (visual) - Add selection to prompt
- `<leader>ar` - Add file reference to prompt
- `:AmpSend <message>` - Send message
- `:AmpSendBuffer` - Send buffer contents

---

## 🔍 Git (Gitsigns)

Signs in gutter show changes. More features available via `:Gitsigns` commands.

---

## ⚙️ Completion (nvim-cmp)

- `<CR>` - Confirm
- `<C-Space>` - Trigger completion
- `<Tab>` - Next item / expand snippet
- `<S-Tab>` - Previous item / jump back

---

## 🛠️ Mason (Package Manager)

- `:Mason` - Open Mason UI
- `:MasonUpdate` - Update packages
- `:MasonToolsInstall` - Install all configured tools

### Installed Tools
**LSP:** gopls, pyright, lua_ls, vtsls, jsonls, yamlls, bashls, dockerls, docker_compose_language_service, clangd, cmake, html, cssls, marksman

**Formatters:** goimports, gofumpt, black, jq, yamlfmt, prettier

**Linters:** golangci-lint, ruff, hadolint



---

## 📋 Quick Reference

### File Operations
- `<leader>e` - File explorer
- `<leader>ff` - Find files
- `<leader>fg` - Search in files
- `<leader>fb` - Open buffers

### Code Navigation
- `gd` - Definition
- `gr` - References
- `<leader>o` - Symbols outline

### Diagnostics
- `<leader>q` - Show all diagnostics
- `[d` / `]d` - Navigate diagnostics

### Editing
- `<C-n>` - Multi-cursor
- `gcc` - Comment line
- `<leader>f` - Format file

---

## 💡 Tips

1. Use `<leader>fk` to search all keymaps
2. Press `<leader>` and wait to see which-key hints
3. Run `:checkhealth` to diagnose issues
4. Use `:Lazy` to manage plugins
5. Treesitter context shows current function/class at top of window
6. LSP highlights references under cursor automatically
