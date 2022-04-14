-- import needed libraries
local gears = require('gears')
local awful = require('awful')
local musicctl = require('musicctl')

-- define modifier key
local modkey = 'Mod4'

-- table of keybinds
-- you will probably want to append this to whatever you are
-- using for keybinds. In this case, a gears.table holds the binds
local keys = gears.table.join(
	awful.key({ modkey }, 'F5', function()
		musicctl.playback_previous()
	end, {
		description = 'play previous song (playerctl)',
		group = 'music',
	}),
	awful.key({ modkey }, 'F6', function()
		musicctl.playback_toggle()
	end, {
		description = 'toggle music playback (playerctl)',
		group = 'music',
	}),
	awful.key({ modkey }, 'F7', function()
		musicctl.playback_next()
	end, {
		description = 'play next song (playerctl)',
		group = 'music',
	}),
	awful.key({ modkey }, 'F8', function()
		musicctl.switch_mode()
	end, {
		description = 'switch playerctl mode',
		group = 'music',
	}),

	awful.key({ modkey, 'Control' }, 'F5', function()
		musicctl.vol_down()
	end, {
		description = 'decrease volume (playerctl)',
		group = 'music',
	}),
	awful.key({ modkey, 'Control' }, 'F6', function()
		musicctl.vol_mute()
	end, {
		description = 'mute volume (playerctl)',
		group = 'music',
	}),
	awful.key({ modkey, 'Control' }, 'F7', function()
		musicctl.vol_up()
	end, {
		description = 'increase volume (playerctl)',
		group = 'music',
	}),
	awful.key({ modkey, 'Control' }, 'F6', function()
		musicctl.vol_blast()
	end, {
		description = 'blast volume (playerctl)',
		group = 'music',
	}),
)

-- append to the global keymap
root.keys(keys)
