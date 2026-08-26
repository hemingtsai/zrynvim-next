-- lua/tools/plugins/gitsigns.lua
-- Git 变更标记（行内 diff 高亮）
return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
        require("gitsigns").setup({
            signs = {
                add          = { text = "│" },
                change       = { text = "│" },
                delete       = { text = "_" },
                topdelete    = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "]c", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { buffer = bufnr, expr = true, desc = "Next hunk" })

                vim.keymap.set("n", "[c", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { buffer = bufnr, expr = true, desc = "Previous hunk" })

                vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
                vim.keymap.set("n", "<leader>gb", gs.blame_line, { buffer = bufnr, desc = "Blame line" })
            end,
        })
    end,
}
