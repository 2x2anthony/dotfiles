-- Base settings

local opt = vim.opt

local settings = {}

function settings.BaseSettings()
    opt.smartcase  = true               -- Enable smart-case searches.
    opt.ignorecase = true               -- Case-insensitive searches.
    opt.incsearch  = true               -- Always search for strings incrementally.
    opt.cursorline = true               -- Highlight line cursor is on
    opt.number     = true               -- Display numbers on the left side.
    opt.tabstop    = 4                  -- Number of spaces per tab.
    opt.shiftwidth = 4                  -- Number of spaces per indent.
    opt.expandtab  = true               -- Spaces, not tabs.
    opt.updatetime = 100                -- Autosave swap file after this amount of time (if nothing is typed).
    opt.autoindent = true               -- Auto indent new lines.
    opt.cindent    = true               -- Use C-style indentations.
    opt.ruler      = true               -- Show line and column information.
    opt.autoread   = true               -- Reload buffer modified outside of Neovim
    opt.showcmd    = true               -- Show command in status bar.
    opt.undolevels = 999999             -- Number of undo levels
    opt.backspace  = "indent,eol,start" -- Backspace behaviour.
    opt.spell      = true               -- Set spell-check enabled by default
    opt.syntax     = "ON"               -- Enable syntax highlighting.
end

return settings
