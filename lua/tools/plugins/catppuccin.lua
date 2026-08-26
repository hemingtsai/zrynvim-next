-- lua/tools/plugins/catppuccin.lua
-- 配色方案：Catppuccin（Mocha 风格）
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = false,
            term_colors = true,
            integrations = {
                cmp = true,
                gitsigns = true,
                telescope = { enabled = true },
                mini = { enabled = true },
                which_key = true,
                mason = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
            },
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
