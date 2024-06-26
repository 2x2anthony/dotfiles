-- Easily access the dotfiles location
local dotfiles = os.getenv("DOTFILES_LOCATION")

local Colours = {}

function Colours.LoadTheme(name)
    -- Manage theme runtime path
    vim.opt.runtimepath:append(string.format("%s/nvim/colours/%s", dotfiles, name))
    
    -- Load the theme
    require(name).load()
end

return Colours
