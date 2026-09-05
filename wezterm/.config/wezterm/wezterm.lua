-- wezterm - Stow package wezterm/.config/wezterm/wezterm.lua -> ~/.config/wezterm/wezterm.lua
-- rarely used (ghostty canonical, kitty occasional), keep Rose Pine Moon consistent
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'rose-pine-moon'
config.font = wezterm.font('FiraCode Nerd Font Mono')
config.font_size = 12.0
config.enable_tab_bar = false
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.use_fancy_tab_bar = false

return config
