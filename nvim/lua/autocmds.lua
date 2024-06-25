local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

local groups = {}

-- Automatic toggles
function CreateNumberToggle()
    local numberToggle = augroup("NumberToggle", {})
    autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {
        group = numberToggle,
        pattern = '',
        command = "set relativenumber"
    })
    autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {
        group = numberToggle,
        pattern = '',
        command = "set norelativenumber"
    })
end

-- Always jump to the last known cursor position.
function CreateKnownCursorPosition()
    local cursorPos = augroup("CursorPos", {})
    autocmd("BufReadPost", {
        group = cursorPos,
        callback = function()
            local row,col = unpack(vim.api.nvim_buf_get_mark(0, "\""))
            if {row,col} ~= {0, 0} then
                vim.api.nvim_win_set_cursor(0, {row, 0})
            end
        end
    })
end

function groups.CreateGroups()
    CreateNumberToggle()
    CreateKnownCursorPosition()
end

return groups
