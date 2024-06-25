-- *.inl files are included in this list as they are implementation
-- files.
local CAndCxxSourceExts = {'c', 'cpp', 'cxx', 'cc', 'inl'}
local CAndCxxHeaderExts = {'h', 'hpp'}

local CAndCxx = {}

function string:endswith(suffix)
    return self:sub(-#suffix) == suffix
end

function CAndCxx.IsCOrCxxFile()
    local bufType = vim.bo.filetype
    return "cpp" == bufType or "c" == bufType
end

local function DoesBufferHaveExtension(exts)
    local bufName = vim.api.nvim_buf_get_name(0)
    for _,ext in ipairs(exts) do
        if bufName:endswith(ext) then
            return true
        end
    end
    return false
end

function CAndCxx.IsCOrCxxHeaderFile()
    if not CAndCxx.IsCOrCxxFile() then
        return false
    end
    return DoesBufferHaveExtension(CAndCxxHeaderExts)
end

function CAndCxx.IsCOrCxxSourceFile()
    if not CAndCxx.IsCOrCxxFile() then
        return false
    end
    return DoesBufferHaveExtension(CAndCxxHeaderExts)
end

return CAndCxx
