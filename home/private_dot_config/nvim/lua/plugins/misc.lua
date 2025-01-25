return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "kdl" } }, -- zellij config
  },

  {
    "andymass/vim-matchup",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        matchup = { enable = true },
      },
    },
    event = "LazyFile",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "" }
    end,
  },

  {
    "martineausimon/nvim-lilypond-suite",
    main = "nvls",
    ft = "ly",
    opts = {},
  },
}
