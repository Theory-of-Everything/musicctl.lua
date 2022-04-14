-- sample theme file with musicctl theme vars
-- define vars
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local theme = {}

-- some theme vars
theme.font          = "sans 8"
theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

-- ... continue contents

-- volume and status widget theme varibles
theme.musicctl_col = "#00ffa2"
theme.musicctl_col_alt "#011901"
theme.musicctl_fg = "#ffffff"
theme.musicctl_bg = "#121212"

-- ... continue contents

return theme
