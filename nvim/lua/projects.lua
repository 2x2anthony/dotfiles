local System = require'system'
local Window = require'window_handling'

local Project = {}

function Project.Build()
    local path = vim.fn.expand("%:p:h")
    if string.len(path) == 0 then
        return
    end

    editorHeight = tonumber(vim.api.nvim_command_output("echo &lines"))
    editorWidth = tonumber(vim.api.nvim_command_output("echo &columns"))

    row = 5
    col = 3

    windowHeight = editorHeight - (row * 2)
    windowWidth = editorWidth - (col * 2)

    local buffer = Window.CreateFloatingBuffer {
        relative = "editor",
        row = row,
        col = col,
        width = windowWidth,
        height = windowHeight
    }

    return System.Open("build", buffer, path)
end

return Project
