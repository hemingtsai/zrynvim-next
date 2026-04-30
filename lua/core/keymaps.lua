-- lua/core/keymaps.lua
-- 全局非插件快捷键

local map = vim.keymap.set

-- Leader 键设为空格（已在前面设置）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 保存与退出
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("n", "<C-q>", ":qa<CR>", { desc = "Quit all" })
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit current buffer" })

-- 窗口移动（Ctrl + hjkl）
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- 调整窗口大小
map("n", "<leader>+", "<C-w>+", { desc = "Increase height" })
map("n", "<leader>-", "<C-w>-", { desc = "Decrease height" })
map("n", "<leader>=", "<C-w>=", { desc = "Equalize windows" })

-- 更好的粘贴（不覆盖寄存器）
map("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })

-- 快速清除搜索高亮
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- 重新加载配置文件（不退出 Neovim）
map("n", "<leader>r", ":so %<CR>", { desc = "Source current file" })

-- 复制全部内容
map("n", "<leader>y", "ggVGy", { desc = "Copy entire file" })

-- 移动到行首/行尾的更好方式
map("n", "H", "^", { desc = "Go to first non-blank" })
map("n", "L", "$", { desc = "Go to end of line" })
