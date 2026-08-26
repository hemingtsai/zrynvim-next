# Zrynvim Next

The Next Gen of Zry Nvim — 基于 Neovim 0.11+ 的手写发行版配置。

## 前置要求

| 依赖 | 用途 | 必须 |
|------|------|------|
| Neovim ≥ 0.11 | 原生 `vim.lsp.config` API | ✅ |
| git | lazy.nvim 自动引导 | ✅ |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Telescope live_grep | ✅ |
| [clangd](https://clangd.llvm.org/) | C/C++ LSP（系统安装） | 按需 |
| [Node.js](https://nodejs.org/) | TypeScript/Tailwind LSP 安装 | 按需 |

## 安装

```bash
# 备份现有配置（如有）
mv ~/.config/nvim ~/.config/nvim.bak

# 克隆并安装
git clone https://github.com/zrynn/zrynvim-next.git ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

首次启动时 lazy.nvim 会自动安装所有插件。通过 `:Mason` 安装所需的 LSP 服务器：

```
:MasonInstall typescript-language-server tailwindcss-language-server lua-language-server
```

## 目录结构

```
.
├── init.lua                         # 入口：加载 core → loader
├── lua/
│   ├── loader.lua                   # lazy.nvim 引导与插件加载入口
│   ├── core/                        # 无插件依赖的基础配置
│   │   ├── options.lua              # 编辑器选项（缩进/搜索/undo 等）
│   │   ├── keymaps.lua              # 全局快捷键（Leader = Space）
│   │   └── autocmds.lua             # 自动命令（恢复光标/自动建目录等）
│   ├── code/
│   │   ├── configs/
│   │   │   └── lsp.lua              # 原生 LSP 配置（clangd/ts_ls/tailwind/lua_ls）
│   │   └── plugins/
│   │       ├── cmp.lua              # nvim-cmp 自动补全 + LuaSnip 片段
│   │       └── mason.lua            # Mason LSP 工具安装器
│   └── tools/
│       └── plugins/
│           ├── catppuccin.lua       # Catppuccin 配色方案
│           ├── gitsigns.lua         # Git 行级变更标记
│           ├── lualine.lua          # 状态栏
│           ├── mini-files.lua       # 文件浏览器（mini.files）
│           ├── telescope.lua        # 模糊查找
│           └── which-key.lua        # 快捷键提示
├── .gitignore
└── LICENSE
```

## 快捷键一览

### Leader 键

Leader 键设为 **空格键**。

### 全局快捷键

| 按键 | 模式 | 功能 |
|------|------|------|
| `<C-s>` | n | 保存文件 |
| `<C-q>` | n | 退出全部 |
| `<leader>w` | n | 保存文件 |
| `<leader>q` | n | 关闭当前 buffer |
| `<C-h/j/k/l>` | n | 窗口左/下/上/右切换 |
| `<leader>+/-/=` | n | 调整窗口大小 |
| `<leader>p` | x | 粘贴（不覆盖寄存器） |
| `<leader>h` | n | 清除搜索高亮 |
| `<leader>r` | n | 重新加载当前文件 |
| `<leader>y` | n | 复制全部内容 |
| `H / L` | n | 行首 / 行尾 |

### LSP 快捷键（代码文件自动加载）

| 按键 | 功能 |
|------|------|
| `gd` | 跳转到定义 |
| `K` | 悬停文档 |
| `gr` | 查找引用 |
| `<leader>rn` | 重命名 |
| `<leader>ca` | 代码操作 |
| `[d / ]d` | 上/下一个诊断 |
| `<leader>d` | 打开诊断浮动窗口 |

### 插件快捷键

| 按键 | 插件 | 功能 |
|------|------|------|
| `<leader>ff` | telescope | 查找文件 |
| `<leader>fg` | telescope | 全局搜索 |
| `<leader>fb` | telescope | 列出 buffer |
| `<leader>fh` | telescope | 帮助标签 |
| `<leader>e` | mini.files | 打开当前文件所在目录 |
| `<leader>E` | mini.files | 浏览当前工作目录 |
| `<leader>gp` | gitsigns | 预览当前 hunk |
| `<leader>gb` | gitsigns | 当前行 blame |

### 补全快捷键

| 按键 | 模式 | 功能 |
|------|------|------|
| `<Tab>` | i/s | 下一项 / 跳转 snippet |
| `<S-Tab>` | i/s | 上一项 |
| `<CR>` | i | 确认选中 |
| `<C-Space>` | i | 强制触发补全 |

## 配置模块说明

### core/options.lua

编辑器基础设置，与插件无关：

- 行号/相对行号、符号列、光标行高亮
- 缩进：4 空格（Tab → 空格），智能缩进
- 搜索：忽略大小写 + 大写时区分
- 持久化 undo（存放在 `~/.local/state/nvim/undo/`）
- 系统剪贴板集成、自动保存

### core/keymaps.lua

全局快捷键，定义 `vim.g.mapleader = " "`。

### core/autocmds.lua

自动命令：

- 恢复上次编辑光标位置
- 按语言自动设置缩进
- 保存时自动创建父目录
- 终端模式自动切换插入模式
- C/C++ 项目自动检测 `compile_commands.json`

### loader.lua

lazy.nvim 引导脚本，通过 `{ import = "目录" }` 自动发现并加载所有插件。新增插件只需在对应目录下创建文件，无需修改入口。

### code/configs/lsp.lua

使用 Neovim 0.11+ 原生 `vim.lsp.config` 配置 LSP：

- **clangd**：系统安装，启用 `--background-index` 和 `--clang-tidy`
- **ts_ls**：Mason 安装，TypeScript/JavaScript
- **tailwindcss**：Mason 安装，Tailwind CSS
- **lua_ls**：Mason 安装，Lua 语言服务

辅助函数 `mason_server_cmd` 优先使用系统二进制，未找到则回退到 Mason 安装路径。

### 代码补全（cmp.lua）

基于 nvim-cmp 的自动补全系统，依赖源：

1. `nvim_lsp` — LSP 服务器补全
2. `luasnip` — 代码片段（VSCode 风格）
3. `buffer` — 缓冲区文本
4. `path` — 文件路径

## 添加新插件

在 `lua/code/plugins/` 或 `lua/tools/plugins/` 下新建 `.lua` 文件，返回一个 [lazy.nvim spec](https://lazy.folke.io/spec) 即可：

```lua
-- lua/tools/plugins/example.lua
return {
    "user/repo-name",
    event = "BufReadPost",  -- 按需加载
    config = function()
        require("example").setup()
    end,
}
```

## 添加新 LSP 服务器

编辑 `lua/code/configs/lsp.lua`，参照现有模式：

1. 在 `mason.lua` 中添加 `ensure_installed`（若用 mason-lspconfig）
2. 在 `lsp.lua` 中添加 `vim.lsp.config` 和 `vim.lsp.enable`

## License

MIT
