-- lua/tools/plugins/which-key.lua
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        require("which-key").setup()
        local wk = require("which-key")
        wk.add({
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git (if any)" },
            { "<leader>t", group = "Toggle" },
            { "<leader>e", group = "File explorer" },
        })
    end,
}
