return {
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require "lualine_require"
      lualine_require.require = require

      local icons = LazyVim.config.icons

      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = ""

      opts.sections = {
        lualine_a = {
          -- stylua: ignore
          { "mode", fmt = function(str) return str:sub(1, 1) end, },
        },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
            padding = { left = 0, right = 1 },
          },
        },
        lualine_c = {
          vim.tbl_extend(
            "force",
            LazyVim.lualine.root_dir { icon = "󱉭" }, -- no space after icon
            { padding = { left = 1, right = 0 } }
          ),
          { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path(), padding = { left = 0, right = 0 } },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {
          Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color "Statement" } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color "Constant" } end,
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = function() return { fg = Snacks.util.color "Debug" } end,
          },
        },
        lualine_y = {
          { "encoding", padding = { left = 1, right = 0 } },
          "fileformat",
        },
        lualine_z = { "progress" },
      }

      opts.extensions = {
        "fzf",
        "lazy",
        "nvim-dap-ui",
        "trouble",
      }
    end,
  },

  {
    "echasnovski/mini.trailspace",
    event = "LazyFile",
    keys = {
      {
        "<leader>ct",
        function()
          local trailspace = require "mini.trailspace"
          trailspace.trim()
          trailspace.trim_last_lines()
        end,
        desc = "Trim Trailing Whitespace",
      },
    },
    opts = {},
  },
}
