return {
  -- Rich in-buffer rendering for headings, tables, code blocks, lists, and links.
  -- Markdown source is revealed automatically while inserting and on the cursor line.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>mr",
        "<Cmd>RenderMarkdown buf_toggle<CR>",
        ft = "markdown",
        desc = "Markdown: Toggle inline rendering",
      },
      {
        "<leader>ms",
        "<Cmd>RenderMarkdown preview<CR>",
        ft = "markdown",
        desc = "Markdown: Side preview",
      },
    },
    opts = {
      completions = { lsp = { enabled = true } },
    },
  },

  -- Markdown-aware editing: links, heading navigation, checkboxes, and tables.
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown" },
    opts = {
      modules = { maps = false },
      path_resolution = {
        primary = "current",
      },
      links = {
        auto_create = false,
      },
      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            silent = true,
            desc = "Markdown: " .. desc,
          })
        end

        map("n", "gf", "<Cmd>MkdnFollowLink<CR>", "Follow link")
        map("n", "]h", "<Cmd>MkdnNextHeading<CR>", "Next heading")
        map("n", "[h", "<Cmd>MkdnPrevHeading<CR>", "Previous heading")
        map({ "n", "v" }, "<leader>mx", "<Cmd>MkdnToggleToDo<CR>", "Toggle checkbox")
        map({ "n", "v" }, "<leader>ml", "<Cmd>MkdnCreateLink<CR>", "Create link")
        map({ "n", "v" }, "<leader>my", "<Cmd>MkdnCreateLinkFromClipboard<CR>", "Link from clipboard")
        map("n", "<leader>mt", "<Cmd>MkdnTableFormat<CR>", "Format table")
        map("n", "<leader>mn", "<Cmd>MkdnUpdateNumbering<CR>", "Renumber list")

        vim.wo.wrap = true
        vim.wo.linebreak = true
        vim.wo.breakindent = true
      end,
    },
  },

  -- Render Mermaid code blocks as images directly inside Neovim.
  {
    "3rd/diagram.nvim",
    ft = { "markdown" },
    dependencies = {
      {
        "3rd/image.nvim",
        lazy = true,
        build = false,
        opts = {
          backend = "kitty",
          processor = "magick_cli",
          integrations = {
            -- diagram.nvim owns Mermaid blocks; avoid image.nvim scanning Markdown twice.
            markdown = { enabled = false },
          },
          max_height_window_percentage = 45,
          window_overlap_clear_enabled = true,
        },
      },
    },
    keys = {
      {
        "<leader>md",
        function()
          require("diagram").show_diagram_hover()
        end,
        ft = "markdown",
        desc = "Markdown: Open diagram",
      },
    },
    opts = function()
      return {
        integrations = {
          require("diagram.integrations.markdown"),
        },
        renderer_options = {
          mermaid = {
            background = "transparent",
            theme = "dark",
            scale = 2,
          },
        },
      }
    end,
  },

  -- Accurate browser preview, including Mermaid diagrams and KaTeX math.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>mp",
        "<Cmd>MarkdownPreviewToggle<CR>",
        ft = "markdown",
        desc = "Markdown: Browser preview",
      },
    },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }
    end,
  },
}