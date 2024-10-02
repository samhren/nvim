return { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'marko-cerovac/material.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()

        require('material').setup({
            custom_colors = function(colors)
                colors.editor.accent = '#F78C6C'
            end
        })

        vim.g.material_style = 'palenight'
        -- Load the colorscheme here
        vim.opt.background = 'dark'
        vim.cmd.colorscheme 'material'
        -- require('material.functions').change_style 'palenight'
        -- You can configure highlights by doing something like
        vim.cmd.hi 'Comment gui=none'

        -- run this lua require('material.functions').change_style("palenight")
        -- to change the style to palenight

    end,
    opts = {
        lualine_style = 'material'
    }
}
