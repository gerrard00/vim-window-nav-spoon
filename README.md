# Vim Window Navigation for macOS

A Hammerspoon configuration that provides vim-style keybindings for focusing macOS windows globally.

## Features

- **Vim-style navigation**: Use `hjkl` keys to focus windows in different directions
- **Configurable hotkey**: Customize the main modifier key combination
- **Global keybindings**: Works system-wide across all applications
- **Smart window detection**: Uses Hammerspoon's built-in functions to find the nearest window

## Installation

### Prerequisites

1. **Install Hammerspoon**: Download from [hammerspoon.org](https://www.hammerspoon.org/)
2. **Grant permissions**: When first running Hammerspoon, grant it accessibility permissions in System Preferences > Security & Privacy > Privacy > Accessibility

### Option 1: Use as a Spoon (Recommended)

The cleanest way to use this is as a Hammerspoon Spoon:

1. **Install the Spoon**:
   ```bash
   cp -r VimWindowNav.spoon ~/.hammerspoon/Spoons/
   ```

2. **Add to your Hammerspoon config** (`~/.hammerspoon/init.lua`):
   ```lua
   hs.loadSpoon("VimWindowNav")
   spoon.VimWindowNav:start()
   ```

3. **Reload Hammerspoon**: Press `Cmd+Ctrl+R` or click "Reload Config"

**Why use the Spoon?** Clean separation, easy management, proper API, and follows Hammerspoon best practices. See [SPOON_USAGE.md](SPOON_USAGE.md) for detailed Spoon documentation.

### Option 2: Simple Integration

1. **Clone or download** this repository to your local machine
2. **Copy the configuration**:
   ```bash
   # Option 1: Replace your existing Hammerspoon config
   cp init.lua ~/.hammerspoon/init.lua
   
   # Option 2: Include in your existing config
   # Add this line to your ~/.hammerspoon/init.lua:
   # dofile("path/to/vim-window-nav/init.lua")
   ```
3. **Reload Hammerspoon**: Press `Cmd+Ctrl+R` in Hammerspoon or click the "Reload Config" button
4. **Test the keybindings**: Try `Ctrl+Alt+j` to focus the window below

**Note:** The root `init.lua` file now automatically loads and starts the Spoon, so you get the same functionality with a simpler setup.

## Keybindings

### Default Configuration
- **Main modifier**: `Ctrl+Alt` (configurable)

### Window Focus (hjkl)
- `Ctrl+Alt+h` - Focus window to the left (west)
- `Ctrl+Alt+j` - Focus window below (south)  
- `Ctrl+Alt+k` - Focus window above (north)
- `Ctrl+Alt+l` - Focus window to the right (east)

## Configuration

### Changing the Main Hotkey

Edit the `hotkey_modifier` in the config section at the top of `init.lua`:

```lua
local config = {
    -- Change this to your preferred modifier combination
    hotkey_modifier = "ctrl+alt",  -- Options: "cmd", "ctrl", "alt", "shift", or combinations
    -- ...
}
```

**Available options**:
- `"cmd"` - Command key only
- `"ctrl"` - Control key only  
- `"alt"` - Option/Alt key only
- `"shift"` - Shift key only
- `"ctrl+alt"` - Control + Option (default)
- `"cmd+alt"` - Command + Option
- `"cmd+ctrl"` - Command + Control
- And other combinations...


### Debug Mode

Enable debug logging to see what the script is doing:

```lua
local config = {
    debug = true,  -- Set to true to enable debug logging
    -- ...
}
```

## How It Works

### Window Focus Algorithm
Uses Hammerspoon's built-in convenience functions:
- `win:focusWindowNorth()` - Focuses the nearest window above
- `win:focusWindowSouth()` - Focuses the nearest window below  
- `win:focusWindowEast()` - Focuses the nearest window to the right
- `win:focusWindowWest()` - Focuses the nearest window to the left

These functions automatically handle finding the closest window in each direction and provide smooth, reliable navigation.

## Troubleshooting

### Keybindings Not Working
1. **Check permissions**: Ensure Hammerspoon has accessibility permissions
2. **Reload config**: Press `Cmd+Ctrl+R` in Hammerspoon
3. **Check conflicts**: Other apps might be using the same keybindings
4. **Try different modifier**: Change `hotkey_modifier` to avoid conflicts

### Windows Not Focusing Correctly
1. **Enable debug mode**: Set `debug = true` in config
2. **Check console**: Look at Hammerspoon console for debug messages
3. **Verify windows**: Ensure windows are visible and on the same screen

### Performance Issues
1. **Disable debug**: Set `debug = false` for better performance
2. **Check other scripts**: Disable other Hammerspoon scripts temporarily

## Advanced Usage

### Integration with Existing Hammerspoon Config

If you already have a Hammerspoon configuration, you can include this as a module:

```lua
-- In your ~/.hammerspoon/init.lua
local vimWindowNav = dofile("path/to/vim-window-nav/init.lua")

-- Access the module functions
vimWindowNav.toggleDebug()  -- Toggle debug mode
vimWindowNav.setHotkeyModifier("cmd+alt")  -- Change hotkey
```

### Custom Keybindings

You can add custom keybindings by extending the configuration:

```lua
-- Add after the main setup
hs.hotkey.bind({"cmd", "ctrl"}, "f", function()
    -- Custom function: focus next window
    local windows = hs.window.orderedWindows()
    local current = hs.window.focusedWindow()
    -- Your custom logic here
end)
```

## Contributing

Feel free to submit issues and enhancement requests! Some ideas for improvements:

- [ ] Window snapping to screen edges
- [ ] Multi-monitor support enhancements
- [ ] Window tiling modes
- [ ] Customizable movement distances
- [ ] Animation effects

## License

This project is open source. Feel free to modify and distribute as needed.

## Acknowledgments

- Built for [Hammerspoon](https://www.hammerspoon.org/) - the most powerful automation tool for macOS
- Inspired by vim's efficient navigation paradigm
- Designed for power users who want keyboard-driven window management
