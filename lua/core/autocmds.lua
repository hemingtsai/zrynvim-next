-- lua/core/autocmds.lua
-- 全局自动命令（与插件无关）

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 通用组
local general = augroup("GeneralSettings", { clear = true })

-- 1. 回到上次编辑位置（对普通文件生效，排除 git commit 等）
autocmd("BufReadPost", {
    group = general,
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- 2. 自动为特定文件类型设置缩进和换行规则
autocmd("FileType", {
    group = general,
    pattern = { "c", "cpp", "javascript", "typescript", "lua", "vim" },
    callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
    end,
})

-- 对 Python 文件使用 4 空格缩进
autocmd("FileType", {
    group = general,
    pattern = "python",
    callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 4
        vim.bo.tabstop = 4
        vim.bo.softtabstop = 4
    end,
})

-- 3. 自动创建父目录（保存文件时如果目录不存在则创建）
autocmd("BufWritePre", {
    group = general,
    pattern = "*",
    callback = function()
        local file = vim.fn.expand("<afile>")
        local dir = vim.fn.fnamemodify(file, ":h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- 4. 进入终端模式时自动切换到插入模式
autocmd("TermOpen", {
    group = general,
    pattern = "*",
    callback = function()
        vim.cmd("startinsert")
    end,
})

-- 5. 离开终端模式时自动保存（可选）
autocmd("TermLeave", {
    group = general,
    pattern = "*",
    callback = function()
        vim.cmd("stopinsert")
    end,
})

-- 6. 针对 C++ 项目，自动设置编译命令（如果存在 compile_commands.json）
autocmd("BufReadPost", {
    group = general,
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
    callback = function()
        local root = vim.fn.findfile("compile_commands.json", ".;")
        if root ~= "" then
            -- 可选：设置 makeprg 或 LSP 根目录
            local dir = vim.fn.fnamemodify(root, ":h")
            vim.bo.makeprg = "make -C " .. dir
        end
    end,
})

-- 7. 关闭自动注释（避免粘贴时产生额外注释）
autocmd("BufEnter", {
    group = general,
    pattern = "*",
    callback = function()
        vim.cmd("set formatoptions-=cro")
    end,
})
