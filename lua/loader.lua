-- loader.lua
-- lazy.nvim 引导与插件加载入口

local stdpath = vim.fn.stdpath
local loop = vim.loop

local function setup_plugins()
    local lazypath = stdpath("data") .. "/lazy/lazy.nvim"

    if not loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end

    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup({
        spec = {
            { import = "code.plugins" },
            { import = "tools.plugins" },
        },
        install = { colorscheme = { "habamax" } },
        checker = { enabled = true },
    })
end

setup_plugins()
