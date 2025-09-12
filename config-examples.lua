-- Configuration Examples for Vim Window Navigation
-- Copy and paste these configurations into your init.lua file

-- ============================================================================
-- EXAMPLE 1: Minimal Configuration (Command key only)
-- ============================================================================
--[[
local config = {
    hotkey_modifier = "cmd",
    debug = false
}
--]]

-- ============================================================================
-- EXAMPLE 2: Control Key Only (Good for avoiding conflicts)
-- ============================================================================
--[[
local config = {
    hotkey_modifier = "ctrl",
    debug = false
}
--]]

-- ============================================================================
-- EXAMPLE 3: Option Key Only (Alternative to Command)
-- ============================================================================
--[[
local config = {
    hotkey_modifier = "alt",
    debug = true  -- Enable debug for troubleshooting
}
--]]

-- ============================================================================
-- EXAMPLE 4: Custom Combination (Command + Option)
-- ============================================================================
--[[
local config = {
    hotkey_modifier = "cmd+alt",
    debug = false
}
--]]

-- ============================================================================
-- EXAMPLE 5: Integration with Existing Hammerspoon Config
-- ============================================================================
--[[
-- If you already have a Hammerspoon configuration, you can include this as a module:

-- Your existing config
hs.window.animationDuration = 0.1  -- Your existing settings
hs.alert.show("Hammerspoon loaded")  -- Your existing alerts

-- Load vim window navigation
local vimWindowNav = dofile("path/to/vim-window-nav/init.lua")

-- Customize the loaded module
vimWindowNav.config.hotkey_modifier = "cmd+ctrl"
vimWindowNav.config.debug = false

-- Add custom keybindings
hs.hotkey.bind({"cmd", "ctrl"}, "f", function()
    -- Custom: Focus next window in order
    local windows = hs.window.orderedWindows()
    local current = hs.window.focusedWindow()
    local currentIndex = 0
    
    for i, win in ipairs(windows) do
        if win:id() == current:id() then
            currentIndex = i
            break
        end
    end
    
    local nextIndex = (currentIndex % #windows) + 1
    windows[nextIndex]:focus()
end)

-- Add window snapping to edges (optional)
hs.hotkey.bind({"cmd", "ctrl"}, "1", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen()
        local frame = screen:frame()
        win:setFrame({
            x = frame.x,
            y = frame.y,
            w = frame.w / 2,
            h = frame.h
        })
    end
end)

hs.hotkey.bind({"cmd", "ctrl"}, "2", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen()
        local frame = screen:frame()
        win:setFrame({
            x = frame.x + frame.w / 2,
            y = frame.y,
            w = frame.w / 2,
            h = frame.h
        })
    end
end)
--]]

-- ============================================================================
-- EXAMPLE 6: Multi-Monitor Enhanced Configuration
-- ============================================================================
--[[
local config = {
    hotkey_modifier = "cmd+ctrl",
    debug = false
}

-- Enhanced multi-monitor support
local function focusWindowAcrossScreens(direction)
    local win = hs.window.focusedWindow()
    if not win then return end
    
    local currentScreen = win:screen()
    local screens = hs.screen.allScreens()
    local currentIndex = 0
    
    -- Find current screen index
    for i, screen in ipairs(screens) do
        if screen:id() == currentScreen:id() then
            currentIndex = i
            break
        end
    end
    
    local targetScreen = nil
    if direction == "west" and currentIndex > 1 then
        targetScreen = screens[currentIndex - 1]
    elseif direction == "east" and currentIndex < #screens then
        targetScreen = screens[currentIndex + 1]
    end
    
    if targetScreen then
        -- Move window to target screen and center it
        local frame = targetScreen:frame()
        win:setFrame({
            x = frame.x + frame.w * 0.25,
            y = frame.y + frame.h * 0.25,
            w = frame.w * 0.5,
            h = frame.h * 0.5
        })
    end
end

-- Add cross-screen navigation
hs.hotkey.bind({"cmd", "ctrl", "shift"}, "h", function()
    focusWindowAcrossScreens("west")
end)

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "l", function()
    focusWindowAcrossScreens("east")
end)
--]]

-- ============================================================================
-- EXAMPLE 7: Gaming/Performance Optimized Configuration
-- ============================================================================
--[[
local config = {
    hotkey_modifier = "ctrl+alt",  -- Less likely to conflict with games
    debug = false  -- Disable debug for better performance
}

-- Add quick window management for gaming
hs.hotkey.bind({"ctrl", "alt"}, "space", function()
    -- Quick maximize/minimize toggle
    local win = hs.window.focusedWindow()
    if win then
        if win:isMaximized() then
            win:unmaximize()
        else
            win:maximize()
        end
    end
end)

hs.hotkey.bind({"ctrl", "alt"}, "m", function()
    -- Quick minimize
    local win = hs.window.focusedWindow()
    if win then
        win:minimize()
    end
end)
--]]

-- ============================================================================
-- EXAMPLE 8: Accessibility-Friendly Configuration
-- ============================================================================
--[[
local config = {
    hotkey_modifier = "cmd+shift",  -- Easy to press combination
    debug = true  -- Enable debug for troubleshooting
}

-- Add visual feedback
local function showWindowInfo()
    local win = hs.window.focusedWindow()
    if win then
        local title = win:title()
        local app = win:application():name()
        hs.alert.show(app .. ": " .. title, 1.0)
    end
end

-- Add window info hotkey
hs.hotkey.bind({"cmd", "shift"}, "i", showWindowInfo)

--]]

-- ============================================================================
-- USAGE INSTRUCTIONS
-- ============================================================================

--[[
To use any of these configurations:

1. Copy the configuration block you want (remove the --[[ and --]] comments)
2. Paste it at the top of your init.lua file, replacing the existing config
3. Reload Hammerspoon (Cmd+Ctrl+R)
4. Test the keybindings

For integration examples (5-8), you'll need to:
1. Keep the main init.lua file as is
2. Add the additional code to your existing Hammerspoon configuration
3. Adjust paths and settings as needed

Remember to:
- Grant accessibility permissions to Hammerspoon
- Check for keybinding conflicts with other applications
- Adjust the hotkey_modifier if you have conflicts
- Enable debug mode if you're having issues
--]]
