return {
  {
    "xvzc/chezmoi.nvim",
    optional = true,
    opts = {
      events = { on_open = { notification = { enable = false } } },
    },
    init = function() end, -- don't run chezmoi edit on file enter
  },
}
