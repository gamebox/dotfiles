local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local tailwindui = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Choose a Component",
        finder = finders.new_oneshot_job({"tailwindui", "-search", "b"}, opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            local item = selection[1]
            local number = vim.split(
                vim.split(item, ")", {plain = true})[1],
                "(",
                {plain = true}
            )[2]
            local html = vim.fn.system("tailwindui -print " .. number)
            vim.api.nvim_put({ html }, "", false, true)
          end)
          return true
        end,
    }):find()
end

return {
    plugin = tailwindui
}
