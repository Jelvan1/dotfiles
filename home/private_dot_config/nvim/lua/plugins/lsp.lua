return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      max_concurrent_installers = 10,
    },
  },
}
