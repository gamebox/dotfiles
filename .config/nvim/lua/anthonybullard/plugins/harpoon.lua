local function toggle_telescope(opts, harpoon_files)
    opts = opts or {}
    local file_paths = {}
    local conf = require("telescope.config").values
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers")
        .new(opts, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        })
        :find()
end

---@param key string
---@param fn fun()
---@param desc string
local function map(key, fn, desc)
    vim.keymap.set("n", key, fn, { desc = "Harpoon: " .. desc })
end

local function config()
    local harpoon = require("harpoon")
    harpoon:setup({})

    vim.keymap.set("n", "<leader>a", function()
        harpoon:list():append()
    end)

    map("<C-e>", function()
        toggle_telescope(require("telescope.themes").get_ivy({}), harpoon:list())
    end, "Open list")
    map("<C-h>", function()
        harpoon:list():select(1)
    end, "Select first item in list")
    map("<C-j>", function()
        harpoon:list():select(2)
    end, "Select second item in list")
    map("<C-k>", function()
        harpoon:list():select(3)
    end, "Select third item in list")
    map("<C-l>", function()
        harpoon:list():select(4)
    end, "Select fourth item in list")
end

return {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = config,
}
