local opt = vim.opt

local Dictionary = {}

-- Toggles whether or not spell-check is enabled.
local spellEnabled = true
function Dictionary.ToggleSpellCheck()
    spellEnabled = not spellEnabled
    opt.spell = spellEnabled
end

return Dictionary
