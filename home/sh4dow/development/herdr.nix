{ config, ... }:

{
  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [theme]
    name = "terminal"
    auto_switch = false

    [ui]
    status_indicators = "symbols"
    sidebar_start_collapsed = true
    sidebar_collapsed_mode = "hidden"
    tab_bar_position = "bottom"
    pane_borders = "auto"
    pane_outer_borders = false
    pane_gaps = false
    pane_scrollbars = false
    sidebar_width = 22
    sidebar_min_width = 18
    sidebar_max_width = 28

    [ui.toast]
    delivery = "herdr"

    [keys]
    prefix = "ctrl+b"
    toggle_sidebar = "prefix+b"
    new_tab = "prefix+c"
    next_tab = "prefix+n"
    previous_tab = "prefix+p"
    switch_tab = "prefix+1..9"
    split_vertical = "prefix+v"
    split_horizontal = "prefix+minus"
    zoom = "prefix+z"
  '';
}
