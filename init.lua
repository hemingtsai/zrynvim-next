-- ~/.config/nvim/init.lua
-- 配置文件入口：加载核心基础设置 -> 自动加载所有原生配置和插件

-- 1. 核心设置（与插件无关）
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- 2. 动态加载所有原生配置（LSP、诊断等）和插件
require("loader")
