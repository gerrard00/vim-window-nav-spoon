--- === VimWindowNav ===
---
--- Vim-style window navigation for macOS using Hammerspoon
---
--- Download: [https://github.com/yourusername/vim-window-nav](https://github.com/yourusername/vim-window-nav)
---
--- This Spoon provides vim-style keybindings (hjkl) for focusing macOS windows globally.
--- It uses Hammerspoon's built-in window focusing functions for reliable navigation.
---
--- ### Features
--- - Vim-style navigation using hjkl keys
--- - Configurable hotkey modifier
--- - Global keybindings that work system-wide
--- - Smart window detection using Hammerspoon's built-in functions
---
--- ### Usage
--- ```lua
--- hs.loadSpoon("VimWindowNav")
--- spoon.VimWindowNav:start()
--- ```
---
--- ### Configuration
--- ```lua
--- hs.loadSpoon("VimWindowNav")
--- spoon.VimWindowNav.hotkey_modifier = "cmd+ctrl"  -- Default
--- spoon.VimWindowNav.debug = false                 -- Default
--- spoon.VimWindowNav:start()
--- ```

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "VimWindowNav"
obj.version = "1.0"
obj.author = "Generated for vim-window-nav project"
obj.homepage = "https://github.com/yourusername/vim-window-nav"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- VimWindowNav.hotkey_modifier
--- Variable
--- The main hotkey modifier combination.
--- Accepts either a string like "ctrl+alt" or a table like {"ctrl","alt"}.
--- Default: "ctrl+alt"
obj.hotkey_modifier = "ctrl+alt"

--- VimWindowNav.debug
--- Variable
--- Enable debug logging. Default: false
obj.debug = false

--- VimWindowNav.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('VimWindowNav')

-- Internal variables
obj._hotkeys = {}

-- Utility functions
local function log(self, message)
    if self.debug then
        self.logger.i(message)
    end
end

-- Normalize modifiers: accept string or table
local function normalizeModifiers(mods)
    if type(mods) == "table" then
        -- Already a table, return as-is (but ensure lowercase)
        local normalized = {}
        for _, mod in ipairs(mods) do
            if type(mod) == "string" then
                table.insert(normalized, mod:lower():match("^%s*(.-)%s*$"))
            end
        end
        return normalized
    elseif type(mods) == "string" then
        -- Parse string like "cmd+ctrl" into table
        local out = {}
        for m in mods:gmatch("[^+]+") do
            m = m:match("^%s*(.-)%s*$")  -- Trim whitespace
            if m and m ~= "" then
                table.insert(out, m:lower())
            end
        end
        return out
    elseif mods == nil then
        return {"ctrl", "alt"}  -- Default fallback
    else
        error("hotkey_modifier must be a string like 'cmd+ctrl' or a table like {'cmd','ctrl'}")
    end
end

-- Pretty-print modifiers for logs
local function modsToString(mods)
    if type(mods) == "table" then
        return table.concat(mods, "+")
    elseif type(mods) == "string" then
        return mods
    else
        return tostring(mods)
    end
end

-- Window management functions using Hammerspoon's built-in convenience functions
local function framesOverlapOnAxis(aStart, aEnd, bStart, bEnd)
    return math.max(aStart, bStart) < math.min(aEnd, bEnd)
end

local function getFrameCenter(f)
    return { x = f.x + f.w / 2, y = f.y + f.h / 2 }
end

local function isInDirection(fromFrame, toFrame, direction)
    local fromCenter = getFrameCenter(fromFrame)
    local toCenter = getFrameCenter(toFrame)

    if direction == "east" then
        return toCenter.x > fromCenter.x and framesOverlapOnAxis(fromFrame.y, fromFrame.y + fromFrame.h, toFrame.y, toFrame.y + toFrame.h)
    elseif direction == "west" then
        return toCenter.x < fromCenter.x and framesOverlapOnAxis(fromFrame.y, fromFrame.y + fromFrame.h, toFrame.y, toFrame.y + toFrame.h)
    elseif direction == "north" then
        return toCenter.y < fromCenter.y and framesOverlapOnAxis(fromFrame.x, fromFrame.x + fromFrame.w, toFrame.x, toFrame.x + toFrame.w)
    elseif direction == "south" then
        return toCenter.y > fromCenter.y and framesOverlapOnAxis(fromFrame.x, fromFrame.x + fromFrame.w, toFrame.x, toFrame.x + toFrame.w)
    end
    return false
end

local function focusWindow(self, direction)
    local win = hs.window.focusedWindow()
    if not win then
        log(self, "No focused window found")
        return
    end

    local currentScreen = win:screen()
    local fromFrame = win:frame()

    -- Iterate windows from front to back to avoid selecting obscured ones
    for _, w in ipairs(hs.window.orderedWindows()) do
        if w ~= win and w:isVisible() then
            local wScreen = w:screen()
            if wScreen and currentScreen and wScreen:id() == currentScreen:id() then
                local toFrame = w:frame()
                if isInDirection(fromFrame, toFrame, direction) then
                    w:focus()
                    log(self, "Focused window " .. direction .. ": " .. (w:title() or "<untitled>"))
                    return
                end
            end
        end
    end

    -- Fallback to Hammerspoon's built-ins if nothing matched (multi-space or off-screen cases)
    local fallback
    if direction == "north" then
        fallback = win:focusWindowNorth()
    elseif direction == "south" then
        fallback = win:focusWindowSouth()
    elseif direction == "east" then
        fallback = win:focusWindowEast()
    elseif direction == "west" then
        fallback = win:focusWindowWest()
    end
    if fallback then
        log(self, "Fallback focused window " .. direction .. ")")
    else
        log(self, "No window found " .. direction)
    end
end

-- Hotkey setup
local function setupHotkeys(self)
    -- Clear existing hotkeys
    self:stop()
    
    local modifiers = normalizeModifiers(self.hotkey_modifier)
    
    -- Focus windows (hjkl)
    self._hotkeys.h = hs.hotkey.bind(modifiers, "h", function()
        log(self, "Focus window west")
        focusWindow(self, "west")
    end)
    
    self._hotkeys.j = hs.hotkey.bind(modifiers, "j", function()
        log(self, "Focus window south")
        focusWindow(self, "south")
    end)
    
    self._hotkeys.k = hs.hotkey.bind(modifiers, "k", function()
        log(self, "Focus window north")
        focusWindow(self, "north")
    end)
    
    self._hotkeys.l = hs.hotkey.bind(modifiers, "l", function()
        log(self, "Focus window east")
        focusWindow(self, "east")
    end)
    
    log(self, "Hotkeys configured with modifier: " .. modsToString(modifiers))
end

--- VimWindowNav:start()
--- Method
--- Start the VimWindowNav Spoon
---
--- Parameters:
---  * None
---
--- Returns:
---  * The VimWindowNav object
function obj:start()
    log(self, "Starting VimWindowNav")
    setupHotkeys(self)
    return self
end

--- VimWindowNav:stop()
--- Method
--- Stop the VimWindowNav Spoon and remove all hotkeys
---
--- Parameters:
---  * None
---
--- Returns:
---  * The VimWindowNav object
function obj:stop()
    log(self, "Stopping VimWindowNav")
    
    -- Disable all hotkeys
    for key, hotkey in pairs(self._hotkeys) do
        if hotkey then
            hotkey:delete()
        end
    end
    self._hotkeys = {}
    
    return self
end

--- VimWindowNav:restart()
--- Method
--- Restart the VimWindowNav Spoon (stop and start)
---
--- Parameters:
---  * None
---
--- Returns:
---  * The VimWindowNav object
function obj:restart()
    log(self, "Restarting VimWindowNav")
    self:stop()
    self:start()
    return self
end

--- VimWindowNav:setHotkeyModifier(newModifier)
--- Method
--- Change the hotkey modifier and restart the Spoon
---
--- Parameters:
---  * newModifier - String containing the new modifier combination
---
--- Returns:
---  * The VimWindowNav object
function obj:setHotkeyModifier(newModifier)
    local normalized = normalizeModifiers(newModifier)
    self.hotkey_modifier = normalized
    log(self, "Hotkey modifier changed to: " .. modsToString(normalized))
    self:restart()
    return self
end

--- VimWindowNav:toggleDebug()
--- Method
--- Toggle debug mode on/off
---
--- Parameters:
---  * None
---
--- Returns:
---  * The VimWindowNav object
function obj:toggleDebug()
    self.debug = not self.debug
    log(self, "Debug mode " .. (self.debug and "enabled" or "disabled"))
    return self
end

--- VimWindowNav:focusWindow(direction)
--- Method
--- Manually focus a window in the specified direction
---
--- Parameters:
---  * direction - String: "north", "south", "east", or "west"
---
--- Returns:
---  * The VimWindowNav object
function obj:focusWindow(direction)
    focusWindow(self, direction)
    return self
end

return obj
