-- lua/tools/plugins/mason.lua
return {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
        require("mason").setup({
            ensure_installed = {
                -- 列出你想通过 Mason 安装的 LSP（不要包括 clangd）
                "typescript-language-server",   -- tsserver
                "tailwindcss-language-server",
                "lua-language-server",
                -- 可以继续添加
            },
            registries = { "github:mason-org/mason-registry" },
            PATH = "prepend",
        })
    end,
}

