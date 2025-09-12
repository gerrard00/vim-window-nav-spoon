-- Vim Window Navigation for Hammerspoon
-- Navigate macOS windows using vim keybindings (hjkl)
-- Author: Generated for vim-window-nav project
--
-- This file provides a simple way to use VimWindowNav without the Spoon structure.
-- For the full Spoon experience with proper API, use VimWindowNav.spoon instead.

-- Load the Spoon
hs.loadSpoon("VimWindowNav")

-- Start with default configuration
spoon.VimWindowNav:start()

-- Return the Spoon for external access
return spoon.VimWindowNav
