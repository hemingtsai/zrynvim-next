-- lua/tools/plugins/mini_files.lua
return {
    "nvim-mini/mini.files",
    version = "*",
    -- 使用 keys 字段确保快捷键在插件加载前即注册
    keys = {
        { "<leader>e", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end, desc = "Open mini.files in current file's directory" },
        { "<leader>E", function() require("mini.files").browse() end, desc = "Browse current working directory" },
    },
    config = function()
        require("mini.files").setup({
            windows = { preview = true, width = 40 },
            mappings = { close = "<ESC>", go_in = "l", go_out = "h" },
        })
    end,
}
