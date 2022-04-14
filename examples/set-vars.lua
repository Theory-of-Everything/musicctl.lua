local musicctl = require('musicctl')

-- table of player names
local modes = { 'vlc', 'firefox' }

-- set the modes
musicctl.set_modes(modes)

-- set the current player to 'firefox'
-- instead of musicctl.modes[1]
-- from the call to set_modes()
musicctl.current_mode = 'firefox'

-- modes can also be set like this
musicctl.set_modes({ 'mpd', 'ncspot' })
