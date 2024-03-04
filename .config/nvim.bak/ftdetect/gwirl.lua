vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.html.gwirl"},
    callback = function ()
        vim.cmd("set filetype=gwirl")

        vim.treesitter.language.register("html", {"gwirl"})
        vim.treesitter.language.require_language("html")
    end
})
