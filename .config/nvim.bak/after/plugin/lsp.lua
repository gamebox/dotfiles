local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.nvim_workspace()

lsp.ensure_installed({
	"tsserver",
	"eslint",
	"rust_analyzer",
	"templ",
	"tailwindcss",
	"html",
	"htmx",
})

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

local function setup_lsp_keybinds(event)
	print("Setting up lsp keybinds")
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	map("gd", vim.lsp.buf.definition, "")
	map("K", function()
		vim.lsp.buf.hover()
	end, "")
	map("<leader>ld", require("telescope.builtin").lsp_definitions, "")
	map("<leader>lD", require("telescope.builtin").lsp_document_symbols, "")
	map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "")
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

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = setup_lsp_keybinds,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local lsp_configurations = require("lspconfig.configs")

if not lsp_configurations.gwirl then
	lsp_configurations.gwirl = {
		default_config = {
			name = "gwirl",
			cmd = { "gwirl-lsp" },
			filetypes = { "gwirl" },
			root_dir = function()
				local dir = vim.fs.dirname(vim.fs.find({ "go.mod" }, { upward = true })[1])
				return dir
			end,
			capabilities = capabilities,
		},
	}
end

if not lsp_configurations.roc then
	lsp_configurations.roc = {
		default_config = {
			name = "roc",
			cmd = { "roc_lang_server" },
			filetypes = { "roc" },
			root_dir = function()
				local dir = vim.fs.dirname(vim.fs.find({ "main.roc" }, { upward = true })[1])
				return dir
			end,
			capabilities = capabilities,
		},
	}
end

local lspconfig = require("lspconfig")

lspconfig.gwirl.setup({})
lspconfig.roc.setup({})
lspconfig.html.setup({
	on_attach = setup_lsp_keybinds,
	filetypes = { "html", "templ", "gwirl" },
})
lspconfig.htmx.setup({
	on_attach = setup_lsp_keybinds,
	filetypes = { "html", "templ", "gwirl" },
})
lspconfig.tailwindcss.setup({
	on_attach = setup_lsp_keybinds,
	filetypes = { "templ", "astro", "javascript", "typescript", "gwirl" },
	init_options = { userLanguages = { templ = "html", gwirl = "html" } },
})
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				-- Tells lua_ls where to find all the Lua files that you have loaded
				-- for your neovim configuration.
				library = {
					"${3rd}/luv/library",
					unpack(vim.api.nvim_get_runtime_file("", true)),
				},
				-- If lua_ls is really slow on your computer, you can try this instead:
				-- library = { vim.env.VIMRUNTIME },
			},
			completion = {
				callSnippet = "Replace",
			},
			-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
			-- diagnostics = { disable = { 'missing-fields' } },
		},
	},
})

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})
