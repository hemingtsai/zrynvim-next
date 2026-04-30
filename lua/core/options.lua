-- lua/core/options.lua
-- Neovim 基础选项配置（全局）

-- 显示与 UI
vim.opt.termguicolors = true           -- 启用 24 位真彩色（需终端支持）
vim.opt.number = true                  -- 显示行号
vim.opt.relativenumber = true          -- 显示相对行号（当前行为绝对行号）
vim.opt.signcolumn = "yes"             -- 始终显示符号列（用于 LSP 诊断、git 标志等）
vim.opt.cursorline = true              -- 高亮当前行
vim.opt.showmatch = true               -- 高亮匹配括号
vim.opt.matchtime = 2                  -- 匹配括号高亮时间（十分之一秒）
vim.opt.laststatus = 3                 -- 全局状态栏（始终显示）

-- 缩进与格式化
vim.opt.tabstop = 4                    -- 制表符宽度（空格数）
vim.opt.shiftwidth = 4                 -- 自动缩进宽度
vim.opt.expandtab = true               -- 将制表符替换为空格
vim.opt.autoindent = true              -- 自动缩进
vim.opt.smartindent = true             -- 智能缩进（尤其对 C 族语言）
vim.opt.breakindent = true             -- 折行时保持缩进

-- 搜索与替换
vim.opt.ignorecase = true              -- 搜索忽略大小写
vim.opt.smartcase = true               -- 若搜索含大写则区分大小写
vim.opt.incsearch = true               -- 实时增量搜索
vim.opt.hlsearch = true                -- 高亮所有搜索结果
vim.opt.gdefault = false               -- 替换时不默认全局（需加 /g）

-- 文件与备份
vim.opt.swapfile = false               -- 禁用交换文件（避免 .swp 污染）
vim.opt.backup = false                 -- 禁用备份文件
vim.opt.writebackup = false            -- 写文件时不再创建备份
vim.opt.undofile = true                -- 启用持久化撤销（撤销历史存文件）
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"  -- 撤销文件存放目录
vim.opt.autoread = true                -- 当文件被外部修改时自动重载

-- 编码与语言
vim.opt.encoding = "utf-8"             -- 内部编码
vim.opt.fileencoding = "utf-8"         -- 文件保存编码
vim.opt.fileformats = "unix,dos,mac"   -- 支持多种换行符格式

-- 性能与行为
vim.opt.timeoutlen = 500               -- 按键序列超时（毫秒），用于 leader 键等
vim.opt.ttimeoutlen = 50               -- 按键码超时
vim.opt.updatetime = 250               -- CursorHold 等事件更新间隔（毫秒）
vim.opt.redrawtime = 1500              -- 重绘超时
vim.opt.lazyredraw = false             -- 重绘时不要懒（避免某些插件闪烁）
vim.opt.synmaxcol = 2000               -- 限制语法高亮列数（提升性能）

-- 剪贴板与鼠标
vim.opt.mouse = "a"                    -- 启用鼠标（所有模式）
vim.opt.clipboard = "unnamedplus"      -- 使用系统剪贴板（Termux 需 termux-clipboard-set 支持，可选）
vim.opt.autowrite = true               -- 当切换 buffer 或执行 make 等命令时自动保存

-- 滚动与光标
vim.opt.scrolloff = 8                  -- 垂直滚动时保持光标上下行数
vim.opt.sidescrolloff = 8              -- 水平滚动时保持光标左右列数
vim.opt.sidescroll = 1                 -- 水平滚动最小步长

-- 命令栏与补全
vim.opt.wildmenu = true                -- 命令行补全增强（显示列表）
vim.opt.wildmode = "list:longest,full" -- 补全模式
vim.opt.wildignore = { "*.o", "*.obj", "*.dll", "*.exe", "*.pyc", "*.class", "node_modules", ".git" }

-- 会话与视图
vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos"
vim.opt.viewoptions = "folds,cursor"

-- 其他
vim.opt.completeopt = "menu,menuone,popup,noselect"  -- 补全菜单行为
vim.opt.conceallevel = 2               -- 隐藏文本（如 markdown 语法标记，设为 0 禁用）
vim.opt.whichwrap = "b,s,h,l,<,>,[,]"  -- 允许左右键跨越行首行尾

-- 持久化撤销目录
local undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undodir = undodir
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p", 448)  -- 448 = 0o700
end
-- 注：无需在此设置 leader 键，leader 通常在 keymaps.lua 中定义
