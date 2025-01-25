return {
  "folke/snacks.nvim",
  dependencies = {
    "NMAC427/guess-indent.nvim",
    opts = {
      filetype_exclude = {
        "alpha",
        "checkhealth",
        "dashboard",
        "help",
        "lazy",
        "lazyterm",
        "lspinfo",
        "mason",
        "notify",
        "packer",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_terminal",
        "snacks_win",
        "terminal",
        "toggleterm",
        "Trouble",
      },
    },
  },
  opts = {
    dashboard = {
      sections = {
        { section = "header" },
        {
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 1,
        },
        { icon = " ", title = "MRU ", file = vim.fn.fnamemodify(".", ":~") },
        {
          section = "recent_files",
          cwd = true,
          limit = 8,
          indent = 2,
          padding = 1,
        },
        {
          icon = " ",
          title = "MRU",
          section = "recent_files",
          limit = 8,
          indent = 2,
          padding = 1,
        },
        { section = "startup" },
      },
    },
    picker = {
      previewers = {
        diff = { builtin = false }, -- use delta
        git = { builtin = false }, -- use delta
      },
      sources = {
        explorer = {
          hidden = true,
          layout = { layout = { position = "right" } },
        },
        files = { hidden = true },
        grep = { hidden = true },
      },
    },
  },
}
