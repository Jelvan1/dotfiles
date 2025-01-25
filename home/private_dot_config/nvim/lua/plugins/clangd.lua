return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.clangd.init_options.fallbackFlags = { "-std=c++20" }
    end,
  },
}
