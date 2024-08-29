vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<left>", function()
    vim.print("Use h to move left!")
end)
vim.keymap.set("n", "<right>", function()
    vim.print("Use l to move right!")
end)
vim.keymap.set("n", "<up>", function()
    vim.print("Use k to move up!")
end)
vim.keymap.set("n", "<down>", function()
    vim.print("Use j to move down!")
end)

vim.keymap.set("n", "<leader>-", vim.cmd.Ex, { desc = "Open explorer" })

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
