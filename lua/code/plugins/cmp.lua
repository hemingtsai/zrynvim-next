return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",       -- LSP 来源
        "L3MON4D3/LuaSnip",           -- 代码片段引擎
        "rafamadriz/friendly-snippets", -- 预置代码片段
        "saadparwaiz1/cmp_luasnip",   -- 代码片段来源
        "hrsh7th/cmp-buffer",         -- 当前缓冲区内容
        "hrsh7th/cmp-path",           -- 文件路径
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load() -- 加载 friendly-snippets

        vim.opt.completeopt = "menu,menuone,preview,noselect"

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },   -- LSP 补全
                { name = "luasnip" },    -- 代码片段
                { name = "buffer" },     -- 缓冲区单词
                { name = "path" },       -- 文件路径
            }),
            formatting = {
                format = function(entry, vim_item)
                    -- 可以添加自定义格式，比如设置符号图标
                    return vim_item
                end,
            },
        })

        -- 手动触发补全快捷键
        vim.keymap.set("i", "<C-Space>", cmp.complete, { desc = "Force completion" })
    end,
}
