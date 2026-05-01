-- loader.lua

local api = vim.api
local stdpath = vim.fn.stdpath
local loop = vim.loop

-- 保存已有的插件列表
local specs = {}

-- 配置文件是否有插件spec
local spec_keys = {
  dependencies = true,
  enabled = true,
  cond = true,
  priority = true,
  init = true,
  opts = true,
  config = true,
  main = true,
  build = true,
  branch = true,
  tag = true,
  commit = true,
  version = true,
  pin = true,
  submodules = true,
  lazy = true,
  event = true,
  cmd = true,
  ft = true,
  keys = true,
  name = true,
  dir = true,
  url = true,
  dev = true,
  import = true,
  optional = true,
  specs = true,
  module = true,
}

-- 判断是否为单个插件 spec
local function has_spec_key(t)
  for k, _ in pairs(t) do
    if type(k) == "string" and spec_keys[k] then
      return true
    end
  end
  return false
end

local function is_single_plugin_spec(t)
  if type(t) ~= "table" then
    return false
  end

  -- { "author/plugin" }
  if type(t[1]) == "string" and t[2] == nil then
    return true
  end

  -- { "author/plugin", config = ..., dependencies = ... }
  if type(t[1]) == "string" and has_spec_key(t) then
    return true
  end

  -- { dir = ... } / { url = ... } / { import = ... }
  if t.dir or t.url or t.import then
    return true
  end

  return false
end

-- 加载插件
local function load_plugins_from_dir(spec)
  if type(spec) == "table" then
    if is_single_plugin_spec(spec) then
      table.insert(specs, spec)  -- 单个插件spec
    else
      vim.list_extend(specs, spec)  -- 插件列表
    end
  else
    api.nvim_err_writeln("Invalid plugin spec: " .. tostring(spec))
  end
end

-- 设置插件
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

  -- 使用 lazy.nvim 官方推荐的配置
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
