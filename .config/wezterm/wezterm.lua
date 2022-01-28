local wezterm = require('wezterm')

return {

    -- Fonts
    font = wezterm.font('Iosevka Term'),
    -- font_size = 14,
    font_size = 15.0,
    line_height = 1.08,

    custom_block_glyphs = false,
    -- foreground_text_hsb = {
    --     hue = 1.0,
    --     saturation = 1.00,
    --     brightness = 1.01,
    -- },
    hide_tab_bar_if_only_one_tab = true,
    window_padding = {
        top = 0,
        left = 0,
        right = 0,
        bottom = 0,
    },
    -- window_background_opacity = 0.96,
    -- text_background_opacity = 0.9,
    use_dead_keys = false, -- For áéíóú
    enable_wayland = true,
    colors = {
        foreground = '#716D8B', -- The default text color
        background = '#191724', -- The default background color

        cursor_bg = '#555169',
        cursor_fg = '#e0def4',
        -- cursor_border = 'orange',

        selection_fg = 'black', -- the foreground color of selected text
        selection_bg = 'orange', -- the background color of selected text

        split = '#3f3c53', -- The color of the split lines between panes

        ansi = { '#26233A', '#b4637a', '#286983', '#D4A76C', '#9CCFD8', '#C4A7E7', '#D7827E', '#E0DEF4' },
        brights = { '#3B425B', '#EB6F92', '#31748F', '#F6C177', '#9CCFD8', '#C4A7E7', '#D7827E', '#E0DEF4' },
        indexed = { [136] = '#af8700' }, -- Arbitrary colors of the palette in the range from 16 to 255
        -- indexed = {[136] = '#716D8B'}, -- Arbitrary colors of the palette in the range from 16 to 255
    },
    force_reverse_video_cursor = true,

    window_close_confirmation = 'NeverPrompt',
    exit_behavior = 'Close',
    skip_close_confirmation_for_processes_named = {
        'zsh',
        'nvim',
    },
    check_for_updates = false,
}
