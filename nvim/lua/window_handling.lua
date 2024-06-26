-------------------------------
-- TODO:
--
-- * Ability to swap buffers in windows

local Window = {}
local panelCount = 1

-- Closes all other windows but the currently selected window.
function Window.CloseOtherWindows()
    vim.cmd [[ only ]]
    panelCount = 1
end

-- Performs a vertical split only if there is only one window.
function Window.VerticalSplit()
    if 2 <= panelCount then
        return
    end

    -- Make the split
    vim.cmd [[
        set splitright
        vsplit
    ]]
    panelCount = panelCount + 1
end

-- Performs a horizontal split only if there is only one window.
function Window.HorizontalSplit()
    if 2 <= panelCount then
        return
    end

    vim.cmd [[ split ]]
    panelCount = panelCount + 1
end

return Window
