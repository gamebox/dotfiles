return {
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "html",
                    "lua",
                    "markdown",
                    "vim",
                    "vimdoc",
                    "javascript",
                    "typescript",
                    "templ",
                    "go",
                    "itch",
                },
                -- Autoinstall languages that are not installed
                auto_install = true,
                sync_install = false,
                highlight = {
                    enable = true,
                    disable = function(_, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })

            local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            treesitter_parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }
            treesitter_parser_config.just = {
                install_info = {
                    url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "main",
                    -- use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
                },
                maintainers = { "@IndianBoy42" },
            }
            treesitter_parser_config.itch = {
                install_info = {
                    url = "https://github.com/gamebox/tree-sitter-itch",
                    files = { "src/parser.c" },
                    branch = "main",
                },
                filetype = "itch",
            }
            treesitter_parser_config.roc = {
                install_info = {
                    url = "https://github.com/gamebox/tree-sitter-roc",
                    files = { "src/parser.c", "src/scanner.c" },
                },
                filetype = "roc",
            }

            vim.treesitter.language.register("templ", "templ")
            vim.treesitter.language.register("just", { "just", "justfile", "Justfile" })
            vim.treesitter.language.register("html", { "gwirl" })
            vim.treesitter.language.register("itch", "itch")
            vim.treesitter.language.register("roc", { "roc" })

            -- There are additional nvim-treesitter modules that you can use to interact
            -- with nvim-treesitter. You should go explore a few and see what interests you:
            --
            --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
            --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
            --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        end,
    },
    "vrischmann/tree-sitter-templ",
    "IndianBoy42/tree-sitter-just",
    "gamebox/tree-sitter-itch",
    "gamebox/tree-sitter-roc",
}
