# ./modules/home/kitty.nix
# Kitty terminal depends on Fish shell and MesloLG Nerd font
{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    themeFile = "tokyo_night_storm";

    # Override theme foreground to pure white.
    extraConfig = ''
      foreground #ffffff
    '';
    
    # Shell configuration
    shellIntegration.enableFishIntegration = true;
    
    settings = {
      # Shell
      shell = "${pkgs.fish}/bin/fish";
      
      # Window layout
      initial_window_width = "120c";
      initial_window_height = "41c";
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
      
      font_size = "12.0";
      disable_ligatures = "never";

      # Better line spacing 
      modify_font = "cell_height 5px";
      modify_font_baseline = "1px";
      
      # macOS settings (see https://sw.kovidgoyal.net/kitty/conf/#os-specific-tweaks)
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_thicken_font = "0";
      # Needed for macOS "press Ctrl twice" dictation shortcut to work reliably.
      # Docs: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.macos_secure_keyboard_entry
      macos_secure_keyboard_entry = "no";

      # Tab bar (minimal style to match terminal aesthetic)
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      # Show: tab index, current directory (last path segment), and current title (usually active app/command)
      tab_title_template = "{index}: {title} /{tab.tive_wd.split('/')[-1]}";
      active_tab_title_template = "{index}: {title} /{tab.active_wd.split('/')[-1]}";
      
      # Performance tuning
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Scrollback
      scrollback_lines = 10000;

      cursor_trail = 1;
      
      # Mouse
      url_style = "curly";
      
      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = 0;  # Disable cursor blink
      
      # Window
      confirm_os_window_close = 1;  # Ask for confirmation when closing windows with running processes
      
      # Background image
      background_image = "${config.home.homeDirectory}/Documents/bmw-terminal-small.jpg";
      background_image_layout = "cscaled";
      background_tint = 0.98;

      # Transparency
      #background_opacity = 0.96;
      #background_blur = 6;

      # Notifications
      notify_on_cmd_finish = "unfocused 30.0";  # Notify only when window unfocused and command takes >30s
      enable_audio_bell = false;
      visual_bell_duration = 0;

      # Remote control (for live config reload)
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty-${config.home.username}";

    };
    
    # Kitty keyboard shortcuts (optional - can be customized)
    keybindings = {
      # Disable @ shortcut (interferes with typing)
      "shift+alt+2" = "no_op";

      # Easy copy / paste

      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";

      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "alt+t" = "new_tab";
      "alt+w" = "close_tab";
      "alt+l" = "next_tab";
      "alt+h" = "previous_tab";
      
      # Jump to specific tabs (Alt+1 through Alt+9)
      "alt+1" = "goto_tab 1";
      "alt+2" = "goto_tab 2";
      "alt+3" = "goto_tab 3";
      "alt+4" = "goto_tab 4";
      "alt+5" = "goto_tab 5";
      
      # Window management
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+w" = "close_window";
      
      # Window navigation (German keyboard: ö/ä for cycling)
      "ctrl+shift+ä" = "next_window";
      "ctrl+shift+ö" = "previous_window";
      
      # Window navigation (vim-style)
      #"alt+h" = "neighboring_window left";
      "alt+j" = "neighboring_window down";
      "alt+k" = "neighboring_window up";
      #"alt+l" = "neighboring_window right";
      
      # Font size
      "ctrl+shift+plus" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+0" = "change_font_size all 0";

      # Shortcuts overlay (like which-key)
      "ctrl+shift+#" = "launch --type=overlay ${pkgs.bash}/bin/bash ${config.home.homeDirectory}/repos/nixos-config/modules/home/kitty-shortcuts.sh";
    };
  };

}
