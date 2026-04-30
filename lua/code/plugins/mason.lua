-- lua/tools/plugins/mason.lua
return {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
        require("mason").setup({
            ensure_installed = {
                "typescript-language-server",
                "tailwindcss-language-server",
                "lua-language-server",
                -- 你可以添加其他工具：stylua, prettier, clang-format 等
            },
            PATH = "prepend",
        })
    end,
}
