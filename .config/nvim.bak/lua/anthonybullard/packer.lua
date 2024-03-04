-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { "catppuccin/nvim", as = "catppuccin" }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use "theprimeagen/harpoon"
    use "theprimeagen/Vim-Be-Good"
    use "mbbill/undotree"
    use "tpope/vim-fugitive"
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'folke/neodev.nvim', opts = {} },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use "nvim-lua/lsp-status.nvim"
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use {
        'nvim-neorg/neorg',
        tag = "v6.2.0",
        after = {
            "nvim-treesitter",
            "telescope.nvim"
        },
        requires = "nvim-lua/plenary.nvim",
        run = ":Neorg sync-parsers"
    }
    use "lukas-reineke/indent-blankline.nvim"
    use "vrischmann/tree-sitter-templ"
    use "folke/zen-mode.nvim"
    use "stevearc/conform.nvim"
end)
