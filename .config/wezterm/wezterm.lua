local wezterm = require 'wezterm';

return {
    -- Fonts

    font = wezterm.font('Cartograph CF'),
    font_size = 14.5,

    -- font = wezterm.font('Iosevka Term'),
    -- font_size = 15,

    hide_tab_bar_if_only_one_tab = true,
    window_close_confirmation = 'NeverPrompt',
    window_padding = {
        top = 0,
        left = 0,
        right = 0,
        bottom = 0,
    },
    use_dead_keys = false,
    colors = {
        foreground = '#716D8B', -- The default text color
        background = '#191724', -- The default background color

        cursor_bg = '#555169',
        cursor_fg = '#e0def4',
        cursor_border = 'orange',

        selection_fg = 'black', -- the foreground color of selected text
        selection_bg = 'orange', -- the background color of selected text

        split = '#3f3c53', -- The color of the split lines between panes

        ansi = {'#26233A', '#b4637a', '#286983', '#D4A76C', '#9CCFD8', '#C4A7E7', '#EBBCBA', '#E0DEF4'},
        brights = {'#6E6A86', '#EB6F92', '#31748F', '#F6C177', '#9CCFD8', '#C4A7E7', '#EBBCBA', '#E0DEF4'},

        indexed = {[136] = '#af8700'}, -- Arbitrary colors of the palette in the range from 16 to 255
    }
}
