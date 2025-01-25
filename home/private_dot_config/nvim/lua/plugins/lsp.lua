return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
      },
    },
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
