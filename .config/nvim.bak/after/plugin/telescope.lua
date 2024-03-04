require("telescope").setup({
	pickers = {
		find_files = {
			theme = "ivy",
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")
require("telescope").load_extension("tailwindui_telescope")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fr", builtin.registers, {})
vim.keymap.set("n", "<leader>fi", builtin.lsp_implementations, {})
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
vim.keymap.set("n", "<leader>ft", builtin.lsp_type_definitions, {})
vim.keymap.set("n", "<leader>fT", require("tailwindui_telescope").plugin, {})
vim.keymap.set("n", "<leader>fw", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>fh", builtin.man_pages, {})
vim.keymap.set("n", "<leader>fs", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
