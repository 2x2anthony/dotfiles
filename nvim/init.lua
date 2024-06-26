--------------------------------
-- TODO
--
--

-- Lua require updates

local dotfiles=os.getenv("DOTFILES_LOCATION")
local luaDir = string.format("%s/nvim/lua/?.lua;", dotfiles)
package.path = luaDir .. package.path

-- Lua stdlib extensions

function string:endswith(suffix)
    return self:sub(-#suffix) == suffix
end

-- Configuration

vim.g.mapleader = " "

require("options").BaseSettings()
require("autocmds").CreateGroups()

-- Plugins

require("plugins").Load('gitsigns').setup()
require("plugins").Load('hop').setup {
    keys = 'etovxqpdygfblzhckisuran',
    current_line_only = false,
    multi_windows = true
}

local hop = require("hop")
local hopDirections = require("hop.hint")

-- Theme
require('colours').LoadTheme('onedark')

-- Useful variables

local keymap   = vim.keymap.set
local normal   = 'n'
local visual   = 'v'
local insert   = 'i'
local terminal = 't'

local function nop()
end

local silent = { silent = true }

-- Functionality

local Window = require("window_handling")
local Dictionary = require("dictionary")
local CxxAndC = require("cxx_and_c")

-- Key bindings


-- Replace colon key
keymap(normal, 'p', ':', silent)

-- Movement keys in normal/visual
keymap({normal, visual}, 'j', "<Left>", silent)
keymap({normal, visual}, 'J', "<C-Left>", silent)
keymap({normal, visual}, 'k', "g<Down>", silent)
keymap({normal, visual}, 'K', '}', silent)
keymap({normal, visual}, 'l', "g<Up>", silent)
keymap({normal, visual}, 'L', '{', silent)
keymap({normal, visual}, ';', "<Right>", silent)
keymap({normal, visual}, ':', "<C-Right>", silent)

-- Movement keys to beginning/end of line

keymap({normal, visual}, 'n', [[ col('.') == match(getline('.'), '\S') + 1 ? '0' : '^' ]], {silent=true; expr=true; remap=true})
keymap({normal, visual}, 'm', '$', {silent=true;remap=true})

-- Movement keys between windows

keymap(normal, '<M-u>', '<C-w>h', silent)
keymap(normal, '<M-i>', '<C-w>j', silent)
keymap(normal, '<M-o>', '<C-w>k', silent)
keymap(normal, '<M-p>', '<C-w>l', silent)

-- Clear highlight and redraw
keymap(normal, '<C-l>', ":nohlsearch<CR>:normal! <CR>", silent)

-- Escape key for :terminal
keymap(terminal, '<Esc>', '<C-\\><C-n>')

-- SAVE!!!!!
keymap(normal, 'w', ":write<CR>", silent)

-- Open a new vertical panel
keymap(normal, "<Leader>vs", Window.VerticalSplit, silent)

-- Open a new horizontal panel
keymap(normal, "<Leader>hs", Window.HorizontalSplit, silent)

-- Close other windows
keymap(normal, "<Leader>w", Window.CloseOtherWindows, silent)

-- Find and replace
keymap(normal, "<Leader>r", ":%s//g<Left><Left>")

-- Next in search
keymap(normal, 's', '/<CR>', silent)

-- Toggle spell check
keymap(normal, "<Leader>s", Dictionary.ToggleSpellCheck, silent)

-- Hop binds
keymap(normal, "<Leader>f", function() hop.hint_words({}) end, {remap=true})


