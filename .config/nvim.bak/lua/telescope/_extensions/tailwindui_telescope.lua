return require("telescope").register_extension {
  setup = function(_, _)
    -- access extension config and user config
  end,
  exports = {
    components = require("tailwindui_telescope").plugin
  },
}
