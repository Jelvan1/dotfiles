return {
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-neorg/tree-sitter-norg",
      "nvim-neorg/tree-sitter-norg-meta",
    },
    lazy = false,
    version = "*", -- latest stable release
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              main = "~/neorg",
            },
            default_workspace = "main",
          },
        },
        ["core.qol.toc"] = { config = { auto_toc = { exit_nvim = false } } },
      },
    },
    keys = {
      { "<leader>oi", "<cmd>Neorg index<cr>", mode = "n", desc = "Index (current workspace)" },
      -- norg buffers only
      { "<leader>ot", "<cmd>Neorg toc right<cr>", mode = "n", ft = "norg", desc = "TOC" },
      { "<leader>or", "<cmd>Neorg return<cr>", mode = "n", ft = "norg", desc = "Return (close norg buffers)" },
      { "<S-CR>", "<Plug>(neorg.itero.next-iteration)", mode = "i", ft = "norg", desc = "Neorg: next iteration" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>o", group = "notes", icon = { icon = "󰠮 ", color = "green" } },
      },
    },
  },

  -- better diffing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {
      file_panel = {
        win_config = {
          position = "right",
        },
      },
      view = {
        merge_tool = {
          layout = "diff4_mixed",
        },
      },
    },
    keys = { { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },
}
