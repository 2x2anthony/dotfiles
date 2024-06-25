--------------------------------
-- TODO
--
--

-- Lua require updates

package.path = string.format("%s/nvim/lua/?.lua;", os.getenv("DOTFILES_LOCATION")) .. package.path

-- Lua stdlib extensions

function string:endswith(suffix)
    return self:sub(-#suffix) == suffix
end

-- Configuration

require("options").BaseSettings()
require("autocmds").CreateGroups()

-- Functionality

local Window = require("window_handling")
local Dictionary = require("dictionary")
local CxxAndC = require("cxx_and_c")

-- Easier access to certain neovim variables

local g        = vim.g                         -- Global variables.
local opt      = vim.opt                       -- Set options.
local augroup  = vim.api.nvim_create_augroup   -- Create/get autocommand group.
local autocmd  = vim.api.nvim_create_autocmd   -- Create autocommand

