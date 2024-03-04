require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    chakra = "~/notes/chakra",
                    timebox = "~/notes/timebox",
                    reading = "~/notes/reading",
                    personal = "~/notes/personal",
                    gwirl = "~/notes/gwirl"
                },
                default_worksapce = "personal",
                index_file = "~/notes/index.norg"
            }
        },
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp"
            }
        },
        ["core.keybinds"] = {
            config = {
                neorg_leader = "<Leader>"
            }
        },
        ["core.export"] = {
            config = {}
        },
        ["core.export.markdown"] = {
            config = {
                extension = "md",
                metadata = {
                    ["end"] = "---",
                    start = "---"
                }
            }
        },
        ["core.concealer"] = {
            config = {}
        },
    }
}

