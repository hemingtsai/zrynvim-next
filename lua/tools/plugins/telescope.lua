return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { "node_modules", ".git", "build", "dist" },
                vimgrep_arguments = {
                    "rg", "--color=never", "--no-heading", "--with-filename",
                    "--line-number", "--column", "--smart-case",
                },
            },
            pickers = {
                find_files = { hidden = true },   -- 显示隐藏文件
            },
            extensions = {
                -- 可在这里启用其他扩展，如 fzf
            },
        })
        -- 可选：加载扩展（如果安装了）
        -- pcall(require("telescope").load_extension, "fzf")
    end,
}
