# ./modules/home/kitty.nix
# Kitty terminal depends on Fish shell and MesloLG Nerd font
{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    themeFile = "Dracula";
    
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
      #font_family = "MesloLGS Nerd Font Mono";
      #bold_font = "MesloLGS Nerd Font Mono Bold";
      #italic_font = "MesloLGS Nerd Font Mono Italic";
      #bold_italic_font = "MesloLGS Nerd Font Mono Bold Italic";
      font_family = "JetBrainsMono Nerd Font";  # Using JetBrains as it has ligature support (neovim)
      bold_font = "JetBrainsMono Nerd Font Bold";
      italic_font = "JetBrainsMono Nerd Font Italic";
      bold_italic_font = "JetBrainsMono Nerd Font Bold Italic";
      
      font_size = "11.0";
      disable_ligatures = "never";

      # Font modifications for better line spacing
      modify_font = "cell_height 5px";
      modify_font_baseline = "1px";
      
      # macOS settings (see https://sw.kovidgoyal.net/kitty/conf/#os-specific-tweaks)
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_thicken_font = "0";

      # Tab bar (minimal style to match terminal aesthetic)
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      
      # Performance tuning
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Scrollback
      scrollback_lines = 10000;
      
      # Mouse
      url_style = "curly";
      
      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = 0;  # Disable cursor blink
      
      # Window
      confirm_os_window_close = 0;  # Don't ask for confirmation when closing
      
      # Background image
      #background_image = "";
      #background_image_layout = "cscaled";
      #background_tint = 0.0;

      # Notifications
      notify_on_cmd_finish = "invisible 10.0";
      enable_audio_bell = false;
      visual_bell_duration = 0;

    };
    
    # Kitty keyboard shortcuts (optional - can be customized)
    keybindings = {
      # Easy copy / paste

      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";

      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      
      # Window management
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+w" = "close_window";
      
      # Font size
      "ctrl+shift+plus" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+0" = "change_font_size all 0";
    };
  };

}
