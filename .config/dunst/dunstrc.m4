[global]
monitor = 0
follow = mouse
geometry = "300x5-20+20"
indicate_hidden = yes
shrink = no
transparency = 0
notification_height = 0
separator_height = 2
padding = 8
horizontal_padding = 8
frame_width = 3
frame_color = "#aaaaaa"
separator_color = frame
sort = yes
idle_threshold = 120
font = Fira Sans Regular 12
line_height = 0
markup = full
format = "<b>%s</b>\n%b"
alignment = left
show_age_threshold = 60
word_wrap = yes
ellipsize = middle
ignore_newline = no
stack_duplicates = true
hide_duplicate_count = false
show_indicators = yes
icon_position = left
max_icon_size = 32
icon_path = PH_HOME/.nix-profile/share/icons/Adwaita/16x16/status/:PH_HOME/.nix-profile/share/icons/Adwaita/16x16/devices/:PH_HOME/.nix-profile/share/icons/hicolor/16x16/status/:PH_HOME/.nix-profile/share/icons/hicolor/16x16/devices/
sticky_history = yes
history_length = 20
title = Dunst
class = Dunst
startup_notification = yes
verbosity = mesg
corner_radius = 0
mouse_left_click = close_current
mouse_middle_click = do_action
mouse_right_click = close_all
[urgency_low]
background = "#222222"
foreground = "#888888"
timeout = 10
[urgency_normal]
background = "#285577"
foreground = "#ffffff"
timeout = 10
[urgency_critical]
background = "#900000"
foreground = "#ffffff"
frame_color = "#ff0000"
timeout = 0