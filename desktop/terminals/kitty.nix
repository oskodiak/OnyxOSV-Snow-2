# Kitty Terminal Configuration
# GPU-accelerated terminal with extensive features

{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    
    font = {
      name = "Hack";
      size = 12;
    };
    
    settings = {
      # Theme
      background_opacity = "0.95";
      dynamic_background_opacity = true;
      
      # Colors (Catppuccin Mocha)
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      
      # Cursor
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      
      # URL
      url_color = "#F5E0DC";
      url_style = "curly";
      
      # Window
      window_padding_width = 8;
      window_border_width = 0;
      draw_minimal_borders = true;
      window_margin_width = 0;
      single_window_margin_width = -1;
      
      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      
      # Terminal
      shell_integration = "enabled";
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Scrollback
      scrollback_lines = 10000;
      scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
      
      # Mouse
      mouse_hide_wait = 3;
      focus_follows_mouse = false;
      pointer_shape_when_grabbed = "arrow";
      default_pointer_shape = "beam";
      pointer_shape_when_dragging = "beam";
      
      # Bell
      enable_audio_bell = false;
      visual_bell_duration = 0;
      window_alert_on_bell = true;
      bell_on_tab = true;
      command_on_bell = "none";
      
      # Advanced
      close_on_child_death = false;
      allow_hyperlinks = true;
      term = "xterm-kitty";
      
      # OS specific
      wayland_titlebar_color = "system";
      linux_display_server = "wayland";
    };
    
    keybindings = {
      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+s" = "paste_from_selection";
      
      # Scrolling
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      
      # Window management
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+n" = "new_os_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      
      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";
      "ctrl+shift+alt+t" = "set_tab_title";
      
      # Font size
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      
      # Misc
      "ctrl+shift+f5" = "load_config_file";
      "ctrl+shift+f6" = "debug_config";
      "ctrl+shift+delete" = "clear_terminal reset active";
      "ctrl+shift+f11" = "toggle_fullscreen";
      "ctrl+shift+u" = "kitten unicode_input";
      "ctrl+shift+f2" = "edit_config_file";
    };
  };
}