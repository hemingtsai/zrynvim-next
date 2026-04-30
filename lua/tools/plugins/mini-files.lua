return {
    "nvim-mini/mini.files",
    version = "*",
    config = function()
        local mini_files = require("mini.files")
        
        -- 插件配置
        mini_files.setup({
            windows = {
                preview = true,   -- 预览文件内容
                width = 40,       -- 窗口宽度
            },
            mappings = {
                close = "<ESC>",  -- 关闭窗口
                go_in = "l",      -- 进入目录或打开文件
                go_out = "h",     -- 返回上级目录
            },
        })

        vim.keymap.set("n", "<leader>e", function()
            mini_files.open(vim.api.nvim_buf_get_name(0))
        end, { desc = "Open mini.files in current file's directory" })

        vim.keymap.set("n", "<leader>E", mini_files.browse, { desc = "Browse current working directory" })
    end,
}
