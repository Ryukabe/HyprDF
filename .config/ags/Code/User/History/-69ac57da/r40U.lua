hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            
            active_border   = color.accent,
            inactive_border = color.bg4,
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 4,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 10,
            render_power = 2,
            color        = "rgba(0a0a0add)",
        },

        blur = {
            enabled           = true,
            size              = 5,
            passes            = 2,
            ignore_opacity    = true,
            noise             = 0.08,
            contrast          = 1,
            brightness        = 0.8,
            xray              = false,
            new_optimizations = true,
        },
    },
})