# musicctl.lua

musicctl.lua is a libaray for [AweseomWM](https://awesomewm.org) that gives
functions to control MPRIS-capable media players.

- [Docs](https://docs.theoryware.net/musicctl/index.html)

## Installation

[playerctl](https://github.com/altdesktop/playerctl) In order for this module to function
properly.

```bash
# clone repo
git clone https://git.sr.ht/~theorytoe/musicctl.lua

# copy file to config dir
cp ./musicctl.lua ~/.config/awesome
```

### Patching musicctl

musicctl was designed to not depend on anything other than the core AweseomWM
library and playerctl. However, there are patches in this repository that add
the following features:

- "floating", top-aligned widgets (needs compositor for transparency) `top_align.patch`
- Animations via [rubato](https://github.com/andOrlando/rubato) `rubato.patch`

You can apply/remove a patch as follows:

```bash
# -b creates a backup file
patch -b < patches/rubato.patch

# -R reverses the above
patch -R < patches/rubato.patch
```

### Generating docs

Docs are generated using [LDoc](https://stevedonovan.github.io/ldoc) in HTML format.

```bash
ldoc musicctl.lua -f markdown
```

## Usage

Example usages are found in `example/`

```lua
-- in rc.lua
local musicctl = require('musicctl')
musicctl.vol_up()
```

## Contributing

See:

- CONTRIBUTING.md 
- [The docs page](https://docs.theoryware.net/musicctl/topics/CONTRIBUTING.md.html)
