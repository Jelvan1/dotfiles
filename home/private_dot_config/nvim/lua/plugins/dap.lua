return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<C-F10>", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<S-F10>", function() require("dap").step_back() end, desc = "Step Back" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "Terminate" },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 60,
          position = "right",
        },
        {
          elements = { "repl", "console" },
          size = 10,
          position = "bottom",
        },
      },
    },
  },
}
