-- lua/loader.lua
-- 职责：
--   1. 安装并配置 lazy.nvim，动态加载 code/plugins 和 tools/plugins 下的所有插件规格
--   2. 递归加载 code/configs 和 tools/configs 下的所有原生配置（非插件，如 LSP、诊断等）

local api = vim.api
local loop = vim.loop
local stdpath = vim.fn.stdpath

-- 递归遍历目录，收集所有 .lua 文件的相对路径（模块形式）
-- @param dir_path: 绝对路径，例如 /home/user/.config/nvim/lua/code/configs
-- @param base_mod: 基础模块名，例如 "code.configs"
-- @return table: 模块名列表，例如 { "code.configs.lsp", "code.configs.features.diagnostic" }
local function collect_lua_modules(dir_path, base_mod)
    local modules = {}
    local handle = loop.fs_scandir(dir_path)
    if not handle then return modules end

    while true do
        local name = loop.fs_scandir_next(handle)
        if not name then break end

        local full_path = dir_path .. "/" .. name
        local stat = loop.fs_stat(full_path)
        if stat and stat.type == "directory" then
            -- 递归子目录，子模块名需拼接
            local sub_modules = collect_lua_modules(full_path, base_mod .. "." .. name)
            for _, mod in ipairs(sub_modules) do
                table.insert(modules, mod)
            end
        elseif name:match("%.lua$") then
            -- 去掉 .lua 后缀，转换成模块名
            local mod_name = base_mod .. "." .. name:sub(1, -5)
            table.insert(modules, mod_name)
        end
    end
    return modules
end

-- 加载原生配置：遍历指定根目录下的所有 .lua 文件并 require
-- @param config_root: 配置根目录的绝对路径，例如 /home/user/.config/nvim/lua/code/configs
-- @param base_module: 对应的 Lua 模块前缀，例如 "code.configs"
local function load_native_configs_from(config_root, base_module)
    local modules = collect_lua_modules(config_root, base_module)
    for _, mod in ipairs(modules) do
        local ok, err = pcall(require, mod)
        if not ok then
            api.nvim_err_writeln("Failed to load native config: " .. mod .. "\n" .. err)
        end
    end
end

-- 公共接口：加载所有原生配置（code 和 tools 下的 configs）
local function load_all_native_configs()
    local config_path = stdpath("config")
    local code_configs_dir = config_path .. "/lua/code/configs"
    local tools_configs_dir = config_path .. "/lua/tools/configs"

    -- 检查目录是否存在再加载
    if loop.fs_stat(code_configs_dir) then
        load_native_configs_from(code_configs_dir, "code.configs")
    end
    if loop.fs_stat(tools_configs_dir) then
        load_native_configs_from(tools_configs_dir, "tools.configs")
    end
end

-- ===== 以下是原有的插件动态加载逻辑 =====
local function load_plugins_from_dir(dir_path, base_mod_prefix)
    local specs = {}
    local handle = loop.fs_scandir(dir_path)
    if not handle then return specs end

    while true do
        local name = loop.fs_scandir_next(handle)
        if not name then break end
        if name:match("%.lua$") then
            local mod_name = base_mod_prefix .. "." .. name:sub(1, -5)
            local ok, spec = pcall(require, mod_name)
            if ok and spec then
                if type(spec) == "table" then
                    if spec[1] then -- 列表
                        vim.list_extend(specs, spec)
                    else
                        table.insert(specs, spec)
                    end
                end
            else
                api.nvim_err_writeln("Failed to load plugin spec: " .. mod_name)
            end
        end
    end
    return specs
end

local function setup_plugins()
    local config_path = stdpath("config")
    local code_plugins_dir = config_path .. "/lua/code/plugins"
    local tools_plugins_dir = config_path .. "/lua/tools/plugins"

    local all_specs = {}
    -- 注意：这里没有递归子目录，如果你希望插件也支持子目录，可以类似 collect 实现
    -- 但一般插件规格直接放在 plugins/ 下即可
    vim.list_extend(all_specs, load_plugins_from_dir(code_plugins_dir, "code.plugins"))
    vim.list_extend(all_specs, load_plugins_from_dir(tools_plugins_dir, "tools.plugins"))

    -- 安装 lazy.nvim（如果没有）
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

    require("lazy").setup(all_specs, {
        install = { colorscheme = { "habamax" } },
        checker = { enabled = true },
    })
end

-- 总的 setup 函数，先加载原生配置，再加载插件（顺序可根据需要调整）
local function setup()
    load_all_native_configs()   -- 先加载原生 LSP、诊断等配置
    setup_plugins()              -- 再加载插件（部分插件可能依赖原生 LSP 已配置）
end

return { setup = setup }
