# ./modules/home/kitty.nix
# Kitty terminal depends on Fish shell and MesloLG Nerd font
{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    
    # Shell configuration
    shellIntegration.enableFishIntegration = true;
    
    settings = {
      # Shell
      shell = "${pkgs.fish}/bin/fish";
      
      # Window layout
      initial_window_width = "130c";
      initial_window_height = "38c";
      window_padding_width = 8;
      remember_window_size = false;
      
      # Font configuration
      font_family = "MesloLGS Nerd Font Mono";
      bold_font = "MesloLGS Nerd Font Mono Bold";
      italic_font = "MesloLGS Nerd Font Mono Italic";
      bold_italic_font = "MesloLGS Nerd Font Mono Bold Italic";
      font_size = "10.0";
      
      # Dracula theme colors
      # Foreground and background
      foreground = "#f8f8f2";
      background = "#20222b";
      
      # Cursor colors
      cursor = "#f8f8f2";
      cursor_text_color = "#20222b";
      
      # Selection colors
      selection_foreground = "#20222b";
      selection_background = "#f8f8f2";
      
      # Normal colors
      color0 = "#21222c";  # black
      color1 = "#ff5555";  # red
      color2 = "#50fa7b";  # green
      color3 = "#f1fa8c";  # yellow
      color4 = "#bd93f9";  # blue
      color5 = "#ff79c6";  # magenta
      color6 = "#8be9fd";  # cyan
      color7 = "#f8f8f2";  # white
      
      # Bright colors
      color8 = "#6272a4";   # bright black
      color9 = "#ff6e6e";   # bright red
      color10 = "#69ff94";  # bright green
      color11 = "#ffffa5";  # bright yellow
      color12 = "#d6acff";  # bright blue
      color13 = "#ff92df";  # bright magenta
      color14 = "#a4ffff";  # bright cyan
      color15 = "#ffffff";  # bright white
      
      # Tab bar (minimal style to match terminal aesthetic)
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      
      # Performance tuning
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Scrollback
      scrollback_lines = 10000;
      
      # Mouse
      url_color = "#8be9fd";
      url_style = "curly";
      
      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = 0;  # Disable cursor blink
      
      # Window
      confirm_os_window_close = 0;  # Don't ask for confirmation when closing
      
      # Advanced
      enable_audio_bell = false;
      visual_bell_duration = 0;
    };
    
    # Kitty keyboard shortcuts (optional - can be customized)
    keybindings = {
      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      
      # Window management
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";
      
      # Font size
      "ctrl+shift+equal" = "change_font_size all +2.0";
      "ctrl+shift+minus" = "change_font_size all -2.0";
      "ctrl+shift+backspace" = "change_font_size all 0";
    };
  };
}
