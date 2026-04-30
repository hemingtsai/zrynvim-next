return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        require("which-key").setup({
            -- 默认配置即可，也可以自定义窗口样式
            preset = "modern",
        })
        -- 注册顶级分组（会在 <leader> 按下时显示）
        local wk = require("which-key")
        wk.add({
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git (if any)" },
            { "<leader>t", group = "Toggle" },
            { "<leader>e", group = "File explorer" },
        })
    end,
}
