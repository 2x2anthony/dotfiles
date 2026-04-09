local dotfiles=os.getenv("DOTFILES_LOCATION")

local Plugins = {}

function Plugins.Load(name, path)
    path = path or name
    if path ~= name then
        path = path .. name
    end
    vim.opt.runtimepath:append(string.format("%s/nvim/plugins/%s", dotfiles, path))

    return require(name)
end

function Plugins.LoadVim(name, path)
    path = path or name
    if path ~= name then
        path = path .. name
    end
    vim.opt.runtimepath:append(string.format("%s/nvim/plugins/%s", dotfiles, path))

    return vim.cmd(string.format("source %s/nvim/plugins/%s", dotfiles, path))
end

return Plugins
