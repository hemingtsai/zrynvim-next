-- ==================== clangd 配置（C/C++） ====================
vim.lsp.config.clangd = {
    -- 启动命令和参数
    cmd = {
        "clangd",
        "--background-index",      -- 后台索引，提升性能
        "--clang-tidy",            -- 启用 clang-tidy 静态检查
    },
    -- 根目录标志：项目根目录下存在这些文件时，clangd 才会启动
    root_markers = { ".git", "compile_commands.json", ".clangd" },
    -- 生效的文件类型
    filetypes = { "c", "cpp", "objc", "objcpp" },
}

-- 启用 clangd
vim.lsp.enable("clangd")

-- ====================  TypeScript 配置   ====================
vim.lsp.config.ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    root_markers = { "package.json", "tsconfig.json", ".git" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
}
vim.lsp.enable("ts_ls")

-- ==================== 通用 LSP 快捷键与诊断 ====================
-- 当任意 LSP 客户端附加到缓冲区时，自动配置快捷键
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, remap = false }

        -- 常用 LSP 映射
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)       -- 跳转到定义
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)             -- 悬浮显示文档
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)   -- 重命名符号
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- 代码操作
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)       -- 查找引用
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts) -- 函数签名帮助

        -- 诊断相关映射
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)     -- 上一个诊断
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)     -- 下一个诊断
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts) -- 显示诊断详情
    end,
})

-- 全局诊断显示配置
vim.diagnostic.config({
    virtual_text = true,   -- 行内显示错误信息
    signs = true,          -- 显示符号列图标
    underline = true,      -- 错误代码下划线
    update_in_insert = false, -- 插入模式下不更新诊断（提升性能）
    severity_sort = true,  -- 按严重程度排序
})
