# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This repo is a personal Neovim configuration (Neovim 0.12+, `lua/` Lua config) managed by **lazy.nvim**. There is no build or test suite — "running" it means opening Neovim and loading the config. `CHEATSHEET.md` is the human-facing keybind reference and is worth keeping in sync when keymaps change.

## Load order & architecture

`init.lua` bootstraps everything in a deliberate order — **do not reorder**:
1. `require("vars")` — sets `mapleader`/`maplocalleader` **first** (before any plugin loads, so plugins capture the right leader) plus core options.
2. Bootstraps lazy.nvim (clones it to `stdpath("data")/lazy` on first run).
3. `require("opts")` then `require("keys")`.
4. `require("lazy").setup("plugins", …)` — imports every module under `lua/plugins/`.

Each `lua/plugins/*.lua` returns a **lazy.nvim spec** (a table of plugin specs). `lua/plugins/init.lua` is the manifest: it `{ import = "plugins.X" }`s each concern-specific module. To add a plugin area, create `lua/plugins/<name>.lua` returning a spec and add an import line to `init.lua`.

### Conventions that span files
- **Keymaps live with their plugin.** `lua/keys.lua` is intentionally empty — every binding is defined in the owning plugin's spec (via lazy's `keys = {}` or inside `config`/`opts`). To change a binding, edit that plugin file, not a central keymap file. Update `CHEATSHEET.md` to match.
- **Two options files, `opts.lua` wins.** `vars.lua` (loaded step 1) and `opts.lua` (loaded step 3) both set editor options and they overlap. `opts.lua` runs later, so its values win — notably indentation is **2 spaces + expandtab globally**, with a FileType autocmd bumping Python to 4. Edit `opts.lua` for indentation/most options; edit `vars.lua` only for things that must exist before plugins load (leader, PATH shims, netrw disable).

## LSP (`lua/plugins/lsp.lua`)

Uses the **new `vim.lsp.config()` / `vim.lsp.enable()` API** (Neovim 0.11+), **not** the legacy `lspconfig.<server>.setup{}`. All servers are declared in one `servers = { … }` table inside the `nvim-lspconfig` `config` function, then a loop registers and enables each. To add/configure a server, add an entry to that table.

Key invariants:
- **Offset encoding is unified to `utf-16` across all servers** (`capabilities.offsetEncoding`), and clangd is explicitly forced to match via `--offset-encoding=utf-16`. Keep any new server consistent — mismatched encodings break multi-server buffers.
- **Mason installs servers/tools**, declared in two places: `mason-lspconfig` `ensure_installed` (LSP servers) and `mason-tool-installer` `ensure_installed` (formatters/linters/CLIs like `tree-sitter-cli`).
- **`sourcekit` (Swift/ObjC) is a special case**: it ships with Xcode (`/usr/bin/sourcekit-lsp`) and is **not** Mason-installable, so it is enabled in the `servers` table but absent from `mason-lspconfig`. It's scoped to `filetypes = { "swift" }` to avoid double-attaching with clangd on C/C++/ObjC.

## Treesitter (`lua/plugins/treesitter.lua`)

Pinned to nvim-treesitter's **`main` branch** (the rewrite), so it uses the new API: `require("nvim-treesitter").install(...)` and `.indentexpr()`, not the old `require("nvim-treesitter.configs").setup{}`. Parsers are listed in `ensure_installed` and installed **asynchronously on the `LazyDone` User autocmd**; highlighting is enabled per-buffer via a `FileType` autocmd calling `vim.treesitter.start`.

Gotcha: some grammars have `generate = true` and ship no pre-generated `parser.c` (e.g. **swift**). Those require the **`tree-sitter` CLI** at install time (nvim-treesitter shells out to `tree-sitter generate`/`build`). The CLI is provided via Mason's `tree-sitter-cli` in `mason-tool-installer`. Without it, such parsers silently fail to build.

## Formatting & linting (`lua/plugins/format.lua`)

- **conform.nvim** for formatting: `<leader>f`, `formatters_by_ft`. Custom formatters go in the `formatters` table (e.g. `swift_format` drives Apple's `swift format -` over stdin because `swift-format` isn't on the plain PATH).
- **nvim-lint** runs on `BufWritePost`/`InsertLeave`. Linters are added to `linters_by_ft` only when the executable is present (`vim.fn.executable(...)`) — follow that guard pattern for new linters.

## Working with the config

There is no test runner. Manage and verify via Neovim itself:

- `:Lazy` — plugin manager UI. `:Lazy sync` (install/update/clean), `:Lazy restore` (pin to `lazy-lock.json`), `:Lazy update` (and commit the changed `lazy-lock.json`).
- `:Mason` / `:MasonInstall <pkg>` — external tools (LSP servers, formatters, `tree-sitter-cli`).
- `:checkhealth` — diagnose LSP/treesitter/provider issues.

**Verify a config change headlessly** (how to smoke-test edits without an interactive session — a config error will print on load):

```sh
# Does the config load cleanly?
nvim --headless "+qa"

# Inspect runtime state after opening a real file (LSP attach, treesitter, etc.)
nvim --headless path/to/File.ext \
  "+lua vim.defer_fn(function()
     print(vim.bo.filetype)
     print(vim.inspect(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({bufnr=0}))))
     print(tostring(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil))
     vim.cmd('qa!')
   end, 3000)"
```

When testing parser builds, check for the compiled artifact directly (`vim.uv.fs_stat(vim.fn.stdpath('data')..'/site/parser/<lang>.so')`) — `find … && echo BUILT` gives false positives because `find` exits 0 even with zero matches.

## Notes

- `plugin/packer_compiled.lua` is a **dead artifact** from a previous packer.nvim setup — nothing references it (config is 100% lazy.nvim). Ignore it; safe to delete.
