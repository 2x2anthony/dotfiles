local System = {}

local function WriteBuffer(buffer, data)
    vim.api.nvim_buf_set_lines(buffer, -1, -1, false, data)
    local result = ""
    for _,line in ipairs(data) do
        result = result .. line .. "\n"
    end
    return result
end

function System.Open(cmd, buffer, workingDirectory)
    local result = ""
    local job = vim.fn.termopen(
        cmd,
        {
            cwd = workingDirectory,
            on_exit = function() end,
            on_stdout = function(jobid, data, event)
                result = result .. WriteBuffer(buffer, data)
            end,
            on_stderr = function(jobid, data, event)
                result = result .. WriteBuffer(buffer, data)
            end
        }
    )

    return result
end

return System
