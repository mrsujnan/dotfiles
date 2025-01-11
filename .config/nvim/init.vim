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
nnoremap <Leader>ee :call ToggleExMode()<CR>

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
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.clangd.setup({
                cmd = { "clangd" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
        end,
    },

    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local mark = require("harpoon.mark")
            local ui = require("harpoon.ui")

            -- Keymaps for Harpoon
            vim.keymap.set("n", "<leader>aa", mark.add_file, { desc = "Add file to Harpoon" })
            vim.keymap.set("n", "<leader>ss", ui.toggle_quick_menu, { desc = "Open Harpoon menu" })
        end,
    },

    -- Autopairs for brackets and quotes
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true, -- Enable Treesitter integration
                disable_filetype = { "TelescopePrompt", "vim" }, -- Disable in specific filetypes
            })
        end,
    },

    -- File Explorer with icons and Nerd Fonts
    {
        "nvim-tree/nvim-tree.lua",  -- File explorer plugin
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" }, -- Required dependencies
        config = function()
            local nvim_tree = require("nvim-tree")

            -- Configure nvim-tree with file icons
            nvim_tree.setup({
                hijack_netrw = true,  -- Hijack netrw to prevent conflicts
                view = {
                    width = 25,  -- Set the width of the tree window
                    side = "left",  -- Open on the left side
                },
                renderer = {
                    icons = {
                        webdev_colors = true,  -- Enable color icons for web development languages
                        show = {
                            file = true,   -- Show file icons
                            folder = true,  -- Show folder icons
                            folder_arrow = true,  -- Show folder arrow icon
                        },
                        glyphs = {
                            default = "",  -- Default file icon
                            symlink = "",  -- Symlink icon
                            folder = {
                                arrow_open = "",  -- Open folder icon
                                arrow_closed = "",  -- Closed folder icon
                            },
                            git = {
                                unstaged = "✗",  -- Unstaged file icon
                                staged = "✓",    -- Staged file icon
                                untracked = "★", -- Untracked file icon
                                deleted = "",   -- Deleted file icon
                                renamed = "➜",   -- Renamed file icon
                                ignored = "◌",   -- Ignored file icon
                            },
                        },
                    },
                },
            })

            -- Keymap for toggling the file explorer
            vim.keymap.set("n", "<leader>ee", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
        end,
    },

    -- fzf file search plugin
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        config = function()
            -- Keymaps for fzf file search
            vim.keymap.set("n", "<leader>ff", ":Files<CR>", { desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", ":GFiles<CR>", { desc = "Find Git Files" })
            vim.keymap.set("n", "<leader>fb", ":Buffers<CR>", { desc = "Find Buffers" })
            vim.keymap.set("n", "<leader>fl", ":Lines<CR>", { desc = "Search Lines" })
        end,
    },

    -- Autocompletion setup
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end,
    },
})
EOF

let g:ex_mode_active = 0

function! ToggleExMode()
    if g:ex_mode_active == 0
        execute 'Ex'
        let g:ex_mode_active = 1
    else
        b#
        let g:ex_mode_active = 0
    endif
endfunction

augroup ExMappings
    autocmd!
    autocmd FileType netrw nnoremap <buffer> a :call CreateFile()<CR>
    autocmd FileType netrw nnoremap <buffer> r :call RenameFile()<CR>
    autocmd FileType netrw nnoremap <buffer> d :call CreateDirectory()<CR>
augroup END

function! CreateFile()
    let l:file = input('Enter filename: ')
    if l:file != ''
        execute 'edit ' . l:file
    endif
endfunction

function! RenameFile()
    let l:old_name = expand('%')
    let l:new_name = input('Rename ' . l:old_name . ' to: ')
    if l:new_name != '' && l:old_name != l:new_name
        execute 'saveas ' . l:new_name
        execute 'bdelete ' . l:old_name
    endif
endfunction

function! CreateDirectory()
    let l:dir = input('Enter directory name: ')
    if l:dir != ''
        execute '!mkdir ' . l:dir
        execute 'e ' . l:dir
    endif
endfunction

nnoremap <leader>rr :%s/
nnoremap <leader>as /
nnoremap <leader>nh :nohlsearch<CR>
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap sx :close<CR>

