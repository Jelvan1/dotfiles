return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>e",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>E",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
    },
    opts = {
      integrations = {
        grep_in_directory = "snacks.picker",
        grep_in_selected_files = "snacks.picker",
      },
      keymaps = {
        copy_relative_path_to_selected_files = false, -- uses realpath
      },
      open_for_directories = true,
    },
  },

  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.animate = { enabled = false }

      local tmp = opts.right
      opts.right = opts.left
      vim.list_extend(opts.right, tmp)
      opts.left = nil
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    opts = {
      provider_selector = function() -- (bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      close_fold_kinds_for_ft = {
        c = { "function_definition" },
        cpp = { "function_definition" },
        rust = { "function_item", "macro_definition" },
      },
    },
    init = function()
      -- https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#usage
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
      vim.keymap.set("n", "zk", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Preview Fold" })
    end,
  },

  {
    "RaafatTurki/hex.nvim",
    cmd = { "HexDump", "HexAssemble", "HexToggle" },
    opts = {},
  },
}
