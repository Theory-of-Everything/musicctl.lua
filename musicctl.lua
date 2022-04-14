--- Fine-grained media player control for awesomewm.
-- Controls playback and volume of MPRIS-compatable media
-- sources.
-- @module musicctl.lua
-- @author TheoryToE
-- @alias M

local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local M = {}

local modes = { 'mpd', 'ncspot' }
M.current_mode = modes[1]

-- local vars
local modeindx = 1
local vol_inc_amt = 0.02 -- going lower than this number will produce odd bugs

--- Primary accent color of widgets
-- @theme beautiful.musicctl_col
-- @tparam string color hex color code (default: '#a7c080')

--- Secondary accent color of widgets
-- @theme beautiful.musicctl_col_alt
-- @tparam string color hex color code (default: '#404d44')

--- Foreground color of widgets
-- @theme beautiful.musicctl_fg
-- @tparam string color hex color code (default: '#d3c6aa')

--- Background color of widgets
-- @theme beautiful.musicctl_bg
-- @tparam string color hex color code (default: '#2f383e')

local thm_col = beautiful.musicctl_col or '#a7c080'
local thm_col_alt = beautiful.musicctl_col_alt or '#404d44'
local thm_fg = beautiful.musicctl_fg or '#d3c6aa'
local thm_bg = beautiful.musicctl_bg or '#2f383e'

-- {{{ helper functions

-- rounded rectangle wrapper
local function rrect(radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

-- trigger and gears.timer objects
local function trigger(timer)
	if timer.started == true then
		timer:again()
	else
		timer:start()
	end
end
-- }}}

-- {{{ widgets

-- {{{ misc

-- volume text for volume widget
local textwid = wibox.widget({
	text = 'vol: nil',
	widget = wibox.widget.textbox,
})

-- title of status widget
local ststitlewid = wibox.widget({
	widget = wibox.widget.textbox,
	forced_height = 20,
	forced_width = 300,
})

-- text area of status widget
local stswid = wibox.widget({
	text = 'nil',
	widget = wibox.widget.textbox,
})
-- }}}

-- {{{ volume indicator widget
-- progressbar for indicating player volume
local volbar = wibox.widget({
	color = thm_col,
	background_color = thm_col_alt,
	max_value = 100,
	value = 10,
	forced_height = 20,
	forced_width = 200,
	shape = rrect(5),
	bar_shape = rrect(5),
	widget = wibox.widget.progressbar,
})

-- container for volbar
local volwid = awful.popup({
	widget = {
		{
			volbar,
			textwid,
			text = M.current_mode,
			layout = wibox.layout.flex.vertical,
		},
		margins = 20,
		widget = wibox.container.margin,
	},
	fg = thm_fg,
	bg = thm_bg,
	ontop = true,
	visible = false,
	shape = rrect(10),
	placement = awful.placement.top,
})
-- }}}

-- {{{ player status widget
-- current player indicator widget
local statuswid = awful.popup({
	widget = {
		{

			ststitlewid,
			stswid,
			layout = wibox.layout.flex.vertical,
		},
		margins = 20,
		widget = wibox.container.margin,
	},
	fg = thm_fg,
	bg = thm_bg,
	ontop = true,
	visible = false,
	shape = rrect(10),
	placement = awful.placement.top,
})
-- }}}

-- {{{ fade timers
-- volume widget fade timer
local vol_timer = gears.timer({
	timeout = 2,
	callback = function()
		volwid.visible = false
	end,
})

-- status widget fade timer
local sts_timer = gears.timer({
	timeout = 2,
	callback = function()
		statuswid.visible = false
	end,
})
-- }}}

-- async func to get shell output and print volume to widget
local function spwn_volwid()
	awful.spawn.easy_async_with_shell('playerctl --player ' .. M.current_mode .. ' volume', function(out)
		vol_timed.target = tonumber(out:gsub('[%p%c%s]', ''):sub(1, -5))
		textwid.text = 'vol: ' .. tonumber(out:gsub('[%p%c%s]', ''):sub(1, -5)) .. '%'
	end)
	volwid.screen = mouse.screen
	volwid.visible = true
	trigger(vol_timer)
end

-- }}}

-- {{{ Mode control

--- Mode control
-- @section modes

--- Iterate through table 'modes', taking control of player
-- @function switch_mode
M.switch_mode = function()
	modeindx = modeindx + 1
	if modeindx > #modes then
		modeindx = 1
	end
	M.current_mode = modes[modeindx]
	stswid.text = M.current_mode
	ststitlewid.text = 'playerctl source:'
	statuswid.screen = mouse.screen
	statuswid.visible = true
	trigger(sts_timer)
end

--- Set the table of controlled modes
-- @function set_modes
-- @tparam table newmodes string array of modes to control
-- @usage
-- M.set_modes({ 'vlc', 'spotify'})
M.set_modes = function(newmodes)
	modes = newmodes
	M.current_mode = newmodes[1]
end
-- }}}

-- {{{ Playback control

--- Playback control
-- @section playback

--- Toggle playback of selected player
-- @function playback_toggle
M.playback_toggle = function()
	awful.spawn.with_shell('playerctl --player ' .. M.current_mode .. ' play-pause')
end

--- Next song of controlled player
-- @function playback_next
M.playback_next = function()
	awful.spawn.with_shell('playerctl --player ' .. M.current_mode .. ' next')
end

--- Previous song of controlled player
-- @function playback_previous
M.playback_previous = function()
	awful.spawn.with_shell('playerctl --player ' .. M.current_mode .. ' previous')
end
-- }}}

-- {{{ Volume Control

--- Volume control
-- @section volume

--- Granular volume increment control
-- @function vol_increment
-- @tparam string amount
-- @usage
-- -- incremental control (increment polarity (+/-) must follow the number with no space)
-- -- don't use this unless you *really* need too
-- vol_increment('0.1-') -- vol down
-- vol_increment('0.1+') -- vol up
M.vol_increment = function(inc)
	awful.spawn.with_shell('playerctl --player ' .. M.current_mode .. ' volume ' .. inc)
	spwn_volwid()
end

--- Increase volume of current player
-- @function vol_up
M.vol_up = function()
	awful.spawn.with_shell('playerctl --player ' .. M.current_mode .. ' volume ' .. vol_inc_amt .. '+')
	spwn_volwid()
end

--- Decrease volume of current player
-- @function vol_down
M.vol_down = function()
	awful.spawn.with_shell('playerctl --player ' .. M.current_mode .. ' volume ' .. vol_inc_amt .. '-')
	spwn_volwid()
end

--- Mute current player
-- @function vol_mute
M.vol_mute = function()
	awful.spawn.with_shell('playerctl --player ' .. M.current_mode .. ' volume 0')
	spwn_volwid()
end

--- Set volume to a constant value
-- @function vol_const
-- @int num volume to set (0.01 - 1), if ooutside these bounds, defaults to 0.02
M.vol_const = function(num)
	if num > 1 then
		num = 0.02
	elseif num < 0.01 then
		num = 0.02
	end
	awful.spawn.with_shell('playerctl --player ' .. M.current_mode .. ' volume ' .. num)
	spwn_volwid()
end

-- }}}

return M

-- vim:ft=lua:fdm=marker
