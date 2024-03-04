require("conform").setup({
	formatters_by_ft = {
		templ = { "templ" },
		go = { "gofmt" },
		lua = { "stylua" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_user_command("Format", function(_)
	require("conform").format({ bufnr = 0 })
end, { range = false })

vim.keymap.set("n", "<leader>F", ":Format<return>", { buffer = true })
