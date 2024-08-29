local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.font_size = 20
config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.line_height = 1.2
config.use_dead_keys = false
config.window_decorations = "RESIZE"

config.leader = { key = "b", mods = "CTRL" }
config.keys = {
	{
		key = ".",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "line_height",
			one_shot = false,
		}),
	},
}

local set_overrides_and_maintain_key_table = function(overrides, window, pane)
	local key_table = window:active_key_table()
	window:set_config_overrides(overrides)
	if key_table then
		window:perform_action(act.ActivateKeyTable({ name = "line_height", one_shot = false }), pane)
	end
end

local increase_line_height = function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.line_height then
		overrides.line_height = config.line_height
	end
	overrides.line_height = overrides.line_height + 0.1
	set_overrides_and_maintain_key_table(overrides, window, pane)
end

local decrease_line_height = function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.line_height then
		overrides.line_height = config.line_height
	end
	overrides.line_height = overrides.line_height - 0.1
	set_overrides_and_maintain_key_table(overrides, window, pane)
end

config.key_tables = {
	line_height = {
		{ key = ".", action = wezterm.action_callback(decrease_line_height) },
		{ key = ",", action = wezterm.action_callback(increase_line_height) },
		{ key = "Escape", action = "PopKeyTable" },
	},
}

return config
