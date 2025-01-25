return {
  {
    "nvim-neorg/neorg",
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
