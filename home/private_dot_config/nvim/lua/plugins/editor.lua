return {
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
    "RaafatTurki/hex.nvim",
    cmd = { "HexDump", "HexAssemble", "HexToggle" },
    opts = {},
  },
}
