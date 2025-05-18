local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.check_for_updates = false
config.color_scheme = "Catppuccin Macchiato"
config.default_prog = { "nu" }
config.enable_kitty_keyboard = true -- support ctrl + shift
config.enable_tab_bar = false
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 11
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
