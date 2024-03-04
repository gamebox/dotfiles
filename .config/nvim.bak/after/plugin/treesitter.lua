require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "rust", "templ" },
	sync_install = false,
	auto_install = true,
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
	highlight = {
		enable = true,
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		additional_vim_regex_highlighting = false,
	},
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.fsharp = {
	install_info = {
		url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
		branch = "develop",
		files = { "src/scanner.cc", "src/parser.c" },
		generate_requires_npm = true,
		requires_generate_from_grammar = true,
	},
	filetype = "fsharp",
}

local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
treesitter_parser_config.templ = {
	install_info = {
		url = "https://github.com/vrischmann/tree-sitter-templ.git",
		files = { "src/parser.c", "src/scanner.c" },
		branch = "master",
	},
}

vim.treesitter.language.register("templ", "templ")
vim.treesitter.language.register("html", { "gwirl" })
vim.treesitter.language.require_language("html")
