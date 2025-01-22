set nocompatible
set showmatch
set ignorecase
set mouse=a
set hlsearch
set incsearch
set tabstop=4
set softtabstop=4
set expandtab
set autoindent
set shiftwidth=4
set number
set relativenumber
set wildmode=longest,list
set cc=80
filetype plugin indent on
syntax on
set clipboard=unnamedplus
set cursorline
set ttyfast

" Key mappings
let mapleader = " "
inoremap jk <Esc>
vnoremap jk <Esc>
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>nh :nohlsearch<CR>
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap sx :close<CR>

" Install lazy.nvim if not already installed
if empty(glob(stdpath('data') . '/lazy/lazy.nvim'))
    silent !git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
endif
set runtimepath+=~/.local/share/nvim/lazy/lazy.nvim

" Plugin configuration
lua << EOF
require("lazy").setup({

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Python LSP with Pyright
            lspconfig.pyright.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt"),
            })

            -- Keybindings for LSP
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
            vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show References" })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover" })
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "luasnip" },
                },
            })
        end,
    },

    -- Treesitter for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "python", "lua", "bash", "json", "yaml", "markdown" },
                highlight = { enable = true },
            })
        end,
    },

    -- Formatting and linting with null-ls
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.diagnostics.flake8,
                },
            })

            -- Format on save
            vim.cmd([[autocmd BufWritePre *.py lua vim.lsp.buf.format()]])
        end,
    },

    -- Lualine status bar
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "dracula",
                },
            })
        end,
    },

    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({})
            vim.keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
        end,
    },

    -- Telescope for fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require("telescope")
            telescope.setup({})
            vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Search Text" })
        end,
    },
})
EOF

set completeopt=menu,menuone,noselect

