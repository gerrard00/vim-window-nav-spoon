# VimWindowNav Spoon Usage

This document explains how to use the VimWindowNav as a Hammerspoon Spoon.

## What is a Spoon?

Spoons are the recommended way to distribute Hammerspoon configurations as reusable modules. They provide a clean API and can be easily installed, configured, and managed.

## Installation Methods

### Method 1: Manual Installation

1. **Copy the Spoon to your Spoons directory:**
   ```bash
   cp -r VimWindowNav.spoon ~/.hammerspoon/Spoons/
   ```

2. **Add to your Hammerspoon config** (`~/.hammerspoon/init.lua`):
   ```lua
   -- Load the Spoon
   hs.loadSpoon("VimWindowNav")
   
   -- Start it with default settings
   spoon.VimWindowNav:start()
   ```

3. **Reload Hammerspoon:** Press `Cmd+Ctrl+R` or click "Reload Config"

### Method 2: Using SpoonInstall (Recommended)

If you have SpoonInstall configured:

```lua
-- In your ~/.hammerspoon/init.lua
hs.loadSpoon("SpoonInstall")

-- Install and configure VimWindowNav
spoon.SpoonInstall:andUse("VimWindowNav", {
    config = {
        hotkey_modifier = "cmd+ctrl",
        debug = false
    },
    start = true
})
```

## Basic Usage

### Simple Setup (Default Configuration)
```lua
hs.loadSpoon("VimWindowNav")
spoon.VimWindowNav:start()
```

This gives you:
- `Ctrl+Alt+h` - Focus window left
- `Ctrl+Alt+j` - Focus window down  
- `Ctrl+Alt+k` - Focus window up
- `Ctrl+Alt+l` - Focus window right

### Custom Configuration
```lua
hs.loadSpoon("VimWindowNav")

-- Configure before starting
spoon.VimWindowNav.hotkey_modifier = "cmd+ctrl"  -- Change modifier keys
spoon.VimWindowNav.debug = true                  -- Enable debug logging

-- Start the Spoon
spoon.VimWindowNav:start()
```

## Configuration Options

### Available Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `hotkey_modifier` | `"ctrl+alt"` | Main modifier key combination |
| `debug` | `false` | Enable debug logging |

### Modifier Key Options

- `"cmd"` - Command key only
- `"ctrl"` - Control key only  
- `"alt"` - Option/Alt key only
- `"shift"` - Shift key only
- `"ctrl+alt"` - Control + Option (default)
- `"cmd+alt"` - Command + Option
- `"cmd+ctrl"` - Command + Control
- Any other combination using `+`

## API Methods

### Core Methods

#### `spoon.VimWindowNav:start()`
Start the Spoon and bind hotkeys.

```lua
spoon.VimWindowNav:start()
```

#### `spoon.VimWindowNav:stop()`
Stop the Spoon and remove all hotkeys.

```lua
spoon.VimWindowNav:stop()
```

#### `spoon.VimWindowNav:restart()`
Restart the Spoon (stop and start).

```lua
spoon.VimWindowNav:restart()
```

### Configuration Methods

#### `spoon.VimWindowNav:setHotkeyModifier(newModifier)`
Change the hotkey modifier and restart.

```lua
spoon.VimWindowNav:setHotkeyModifier("cmd+alt")
```

#### `spoon.VimWindowNav:toggleDebug()`
Toggle debug mode on/off.

```lua
spoon.VimWindowNav:toggleDebug()
```

### Manual Control Methods

#### `spoon.VimWindowNav:focusWindow(direction)`
Manually focus a window in the specified direction.

```lua
spoon.VimWindowNav:focusWindow("north")  -- or "south", "east", "west"
```

## Advanced Examples

### Multiple Configurations
```lua
hs.loadSpoon("VimWindowNav")

-- Different modifier for different contexts
if hs.application.get("iTerm2") then
    spoon.VimWindowNav.hotkey_modifier = "ctrl+alt"  -- Avoid conflicts with terminal
else
    spoon.VimWindowNav.hotkey_modifier = "cmd+ctrl"  -- Default for other apps
end

spoon.VimWindowNav:start()
```

### Conditional Loading
```lua
-- Only load if multiple monitors are detected
if #hs.screen.allScreens() > 1 then
    hs.loadSpoon("VimWindowNav")
    spoon.VimWindowNav.debug = true  -- Debug for multi-monitor setups
    spoon.VimWindowNav:start()
end
```

### Integration with Other Spoons
```lua
hs.loadSpoon("VimWindowNav")
hs.loadSpoon("WindowGrid")  -- Another window management Spoon

-- Configure both
spoon.VimWindowNav.hotkey_modifier = "cmd+ctrl"
spoon.WindowGrid.hotkey_modifier = "cmd+shift"

-- Start both
spoon.VimWindowNav:start()
spoon.WindowGrid:start()
```

### Custom Keybindings
```lua
hs.loadSpoon("VimWindowNav")

-- Start the Spoon
spoon.VimWindowNav:start()

-- Add custom keybindings that use the Spoon's methods
hs.hotkey.bind({"cmd", "shift"}, "f", function()
    -- Custom function: focus next window clockwise
    spoon.VimWindowNav:focusWindow("east")
end)
```

## Troubleshooting

### Spoon Not Loading
1. Check that the Spoon is in the correct location: `~/.hammerspoon/Spoons/VimWindowNav.spoon/`
2. Verify the `init.lua` file exists in the Spoon directory
3. Check Hammerspoon console for error messages

### Keybindings Not Working
1. Ensure you called `:start()` after loading the Spoon
2. Check for conflicts with other applications
3. Try a different `hotkey_modifier`
4. Enable debug mode to see what's happening

### Debug Mode
```lua
spoon.VimWindowNav.debug = true
spoon.VimWindowNav:start()
```

Then check the Hammerspoon console for log messages.

## Uninstalling

To remove the Spoon:

1. **Stop the Spoon** (optional, but clean):
   ```lua
   spoon.VimWindowNav:stop()
   ```

2. **Remove from your config** - Delete or comment out the lines in `~/.hammerspoon/init.lua`

3. **Delete the Spoon directory**:
   ```bash
   rm -rf ~/.hammerspoon/Spoons/VimWindowNav.spoon
   ```

4. **Reload Hammerspoon** to apply changes

## Benefits of Using as a Spoon

✅ **Clean separation** - Doesn't clutter your main `init.lua`  
✅ **Easy to manage** - Simple to enable/disable/configure  
✅ **Reusable** - Can be shared and installed on multiple machines  
✅ **Proper API** - Well-defined methods and configuration options  
✅ **Logging** - Built-in logging system for debugging  
✅ **Standard structure** - Follows Hammerspoon best practices  

## Comparison: Spoon vs Direct Integration

| Aspect | Spoon | Direct Integration |
|--------|-------|-------------------|
| Setup complexity | Simple `hs.loadSpoon()` | Copy/paste code |
| Configuration | Clean API | Modify variables directly |
| Updates | Replace Spoon folder | Manual code updates |
| Sharing | Easy to distribute | Share code snippets |
| Debugging | Built-in logging | Manual print statements |
| Management | Start/stop methods | Manual enable/disable |
