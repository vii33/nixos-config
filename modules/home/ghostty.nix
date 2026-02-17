# ./modules/home/ghostty.nix

{ config, pkgs, ... }:

let
  bgImage = "${config.home.homeDirectory}/Documents/bmw-terminal-small.jpg";
in
{
  

  xdg.configFile."ghostty/config".text = ''
    # Managed by Home Manager (modules/home/ghostty.nix)
    # Docs: https://ghostty.org/docs/config

    # Shell
    command = "${pkgs.fish}/bin/fish"
    
    # TERM (full color support)
    # Note: if you hit SSH/ncurses issues on remote hosts (missing terminfo), switch to "xterm-256color".
    term = "xterm-ghostty"

    # macOS: map ONLY the left Option key to Alt/Meta.
    macos-option-as-alt = left

    # Theme (others: Ayu)
    theme = TokyoNight
    
    # Force pure white default text (override theme foreground)
    foreground = ffffff

    # Keybindings (Kitty parity)
    # - "performable:" makes Ctrl+C behave like Kitty's "copy_or_interrupt"
    #   (copy only when there is a selection; otherwise let Ctrl+C reach the shell)
    keybind = performable:ctrl+c=copy_to_clipboard
    keybind = ctrl+v=paste_from_clipboard

    # Tab management (disabled; superseded by Zellij)
    # keybind = ctrl+shift+t=new_tab
    # keybind = ctrl+shift+q=close_tab
    # keybind = alt+t=new_tab
    # keybind = alt+w=close_tab
    # keybind = alt+h=previous_tab
    # keybind = alt+l=next_tab
    # keybind = alt+1=goto_tab:1
    # keybind = alt+2=goto_tab:2
    # keybind = alt+3=goto_tab:3
    # keybind = alt+4=goto_tab:4
    # keybind = alt+5=goto_tab:5

    # Split management (Kitty calls these "windows") (disabled; superseded by Zellij)
    # keybind = ctrl+shift+enter=new_split:auto
    # keybind = ctrl+shift+w=close_surface
    # keybind = ctrl+shift+ä=goto_split:next
    # keybind = ctrl+shift+ö=goto_split:previous
    # keybind = alt+j=goto_split:down
    # keybind = alt+k=goto_split:up

    # Font size
    # Note: "equal" is the "+" key on most layouts when used with Shift.
    keybind = ctrl+shift+equal=increase_font_size:1
    keybind = ctrl+shift+minus=decrease_font_size:1
    keybind = ctrl+shift+0=reset_font_size

    # Window layout (columns/rows)
    window-width = 120
    window-height = 41
    window-padding-x = 8
    window-padding-y = 8

    # Font configuration
    font-family = "JetBrainsMono Nerd Font"
    #font-family-bold = "JetBrainsMono Nerd Font Bold"
    #font-family-italic = "JetBrainsMono Nerd Font Italic"
    #font-family-bold-italic = "JetBrainsMono Nerd Font Bold Italic"
    font-size = 12
    adjust-cell-height = 10%
 
    # Background image (PNG/JPEG)
    background-image = "${bgImage}"
    background-image-fit = cover
    background-image-position = center
    background-image-opacity = 0.05

    # Transparency (optional; macOS requires restart)
    #background-opacity = 0.96
    #background-blur = 6
  '';
}
