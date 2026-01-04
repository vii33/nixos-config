# ./modules/home/kitty-hm.nix
# Kitty terminal configuration via Home Manager file management
# Works on both NixOS and macOS (where Kitty is installed via brew)
{ config, pkgs, lib, ... }:

let
  # Detect platform for conditional paths
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  
  # Fish shell path - using Nix-installed Fish on both platforms
  fishPath = "${pkgs.fish}/bin/fish";
  
  # Kitty configuration content
  kittyConfig = ''
    # Shell
    shell ${fishPath}
    
    # Window layout
    initial_window_width 130c
    initial_window_height 38c
    window_padding_width 8
    remember_window_size no
    
    # Font configuration
    # Alternative: MesloLGS Nerd Font Mono
    #font_family MesloLGS Nerd Font Mono
    #bold_font MesloLGS Nerd Font Mono Bold
    #italic_font MesloLGS Nerd Font Mono Italic
    #bold_italic_font MesloLGS Nerd Font Mono Bold Italic
    font_family JetBrainsMono Nerd Font
    bold_font JetBrainsMono Nerd Font Bold
    italic_font JetBrainsMono Nerd Font Italic
    bold_italic_font JetBrainsMono Nerd Font Bold Italic
    font_size 11.0
    disable_ligatures never
    
    # Tab bar (minimal style to match terminal aesthetic)
    tab_bar_edge top
    tab_bar_style powerline
    tab_powerline_style slanted
    
    # Performance tuning
    repaint_delay 10
    input_delay 3
    sync_to_monitor yes
    
    # Scrollback
    scrollback_lines 10000
    
    # Mouse
    url_style curly
    
    # Cursor
    cursor_shape block
    cursor_blink_interval 0
    
    # Window
    confirm_os_window_close 0
    
    # Background image (optional)
    #background_image 
    #background_image_layout cscaled
    #background_tint 0.0
    
    # Notifications
    notify_on_cmd_finish invisible 10.0
    enable_audio_bell no
    visual_bell_duration 0.0
    
    # Theme - Dracula
    # You can also use: include dracula.conf
    # But for portability, we'll use the color values directly
    foreground #f8f8f2
    background #282a36
    selection_foreground #ffffff
    selection_background #44475a
    
    cursor #f8f8f2
    cursor_text_color background
    
    url_color #8be9fd
    
    # Black
    color0 #21222c
    color8 #6272a4
    
    # Red
    color1 #ff5555
    color9 #ff6e6e
    
    # Green
    color2 #50fa7b
    color10 #69ff94
    
    # Yellow
    color3 #f1fa8c
    color11 #ffffa5
    
    # Blue
    color4 #bd93f9
    color12 #d6acff
    
    # Magenta
    color5 #ff79c6
    color13 #ff92df
    
    # Cyan
    color6 #8be9fd
    color14 #a4ffff
    
    # White
    color7 #f8f8f2
    color15 #ffffff
    
    # Keyboard shortcuts
    # Easy copy/paste
    map ctrl+c copy_or_interrupt
    map ctrl+v paste_from_clipboard
    
    # Tab management
    map ctrl+shift+t new_tab
    map ctrl+shift+q close_tab
    map ctrl+shift+right next_tab
    map ctrl+shift+left previous_tab
    
    # Window management
    map ctrl+shift+enter new_window_with_cwd
    map ctrl+shift+w close_window
    
    # Font size
    map ctrl+shift+plus change_font_size all +1.0
    map ctrl+shift+minus change_font_size all -1.0
    map ctrl+shift+0 change_font_size all 0
    
    # macOS specific tweaks (see https://sw.kovidgoyal.net/kitty/conf/#os-specific-tweaks)
    ${lib.optionalString isDarwin ''
    macos_option_as_alt yes
    macos_quit_when_last_window_closed yes
    macos_thicken_font 0.75
    ''}
  '';

in
{
  # Copy Kitty configuration to ~/.config/kitty/kitty.conf
  # This works on both NixOS and macOS
  home.file.".config/kitty/kitty.conf" = {
    text = kittyConfig;
  };
}
