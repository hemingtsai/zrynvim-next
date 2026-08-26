-- lua/code/configs/lsp.lua
-- clangd 使用系统安装的，其他 LSP 通过 Mason 安装（但路径自动检测）

-- 辅助函数：获取 Mason 安装的服务器命令（如果已安装）
local function mason_server_cmd(server_name, default_cmd)
    local ok, mason_registry = pcall(require, "mason-registry")
    if not ok then return default_cmd end
    local pkg = mason_registry.get_package(server_name)
    if pkg and pkg:is_installed() then
        local bin_path = pkg:get_install_path() .. "/bin/" .. default_cmd[1]
        return { bin_path, unpack(default_cmd, 2) }
    end
    return default_cmd
end

-- clangd (系统安装)
vim.lsp.config.clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
    root_markers = { ".git", "compile_commands.json", ".clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
}
vim.lsp.enable("clangd")

-- TypeScript (通过 Mason)
vim.lsp.config.ts_ls = {
    cmd = mason_server_cmd("typescript-language-server", { "typescript-language-server", "--stdio" }),
    root_markers = { "package.json", "tsconfig.json", ".git" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
}
vim.lsp.enable("ts_ls")

-- Tailwind CSS
vim.lsp.config.tailwindcss = {
    cmd = mason_server_cmd("tailwindcss-language-server", { "tailwindcss-language-server", "--stdio" }),
    root_markers = { "package.json", "tailwind.config.js", ".git" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css" },
}
vim.lsp.enable("tailwindcss")

-- Lua LSP
vim.lsp.config.lua_ls = {
    cmd = mason_server_cmd("lua-language-server", { "lua-language-server" }),
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    filetypes = { "lua" },
    settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } } } },
}
vim.lsp.enable("lua_ls")

-- LSP 附加通用快捷键
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    severity_sort = true,
})
