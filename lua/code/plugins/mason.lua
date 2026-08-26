-- lua/code/plugins/mason.lua
-- LSP 工具安装器：运行 :Mason 手动安装服务器
return {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
        require("mason").setup({
            PATH = "prepend",
        })
    end,
}
