local function on_lsp_attach(event)
    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "")
    map("K", function()
        vim.lsp.buf.hover()
    end, "")
    -- map("<leader>ld", require("telescope.builtin").lsp_definitions, "")
    -- map("<leader>lD", require("telescope.builtin").lsp_document_symbols, "")
    -- map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "")
    map("<leader>la", vim.lsp.buf.code_action, "")
    map("<leader>lr", vim.lsp.buf.references, "")
    map("<leader>ln", vim.lsp.buf.rename, "")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

local function config()
    require("neodev").setup({ configure_jsonls = false })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = on_lsp_attach,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local servers = {
        lua_ls = {
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace",
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                    -- diagnostics = { disable = { 'missing-fields' } },
                },
            },
        },
        html = { filetypes = { "html", "templ", "gwirl" } },
        htmx = { filetypes = { "html", "templ", "gwirl" } },
        tailwindcss = {
            filetypes = { "html", "templ", "gwirl", "astro", "javascript", "typescript" },
            init_options = { userLanguages = { templ = "html", gwirl = "html" } },
        },
    }

    require("mason").setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
        "stylua", -- Used to format lua code
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
        handlers = {
            function(server_name)
                local server = servers[server_name] or {}
                -- This handles overriding only values explicitly passed
                -- by the server configuration above. Useful when disabling
                -- certain features of an LSP (for example, turning off formatting for tsserver)
                server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                require("lspconfig")[server_name].setup(server)
                require("lspconfig")["roc_ls"].setup({ filetypes = { "roc" } })
            end,
        },
    })
    vim.diagnostic.config({
        virtual_text = true,
    })
end

return {
    { "folke/neodev.nvim", opts = {} },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = config,
    },
    {
        "S1M0N38/love2d.nvim",
        cmd = "LoveRun",
        opts = {},
        keys = {
            { "<leader>v", ft = "lua", desc = "LÖVE" },
            { "<leader>vv", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
            { "<leader>vs", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
        },
    },
}
