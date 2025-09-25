# ./modules/default.nix
{ config, pkgs, ... }:

{
# Enable Fish shell
programs.fish = {
  enable = true;
  
  # Run Tide's non-interactive configurator once
  interactiveShellInit = ''
    # Only run if Tide hasn't been configured yet on this machine
    if not set -q tide_prompt_transient_enabled
      tide configure --auto \
        --style=Rainbow \
        --prompt_colors='True color' \
        --show_time=No \
        --rainbow_prompt_separators=Slanted \
        --powerline_prompt_heads=Slanted \
        --powerline_prompt_tails=Flat \
        --powerline_prompt_style='Two lines, character' \
        --prompt_connection=Dotted \
        --powerline_right_prompt_frame=No \
        --prompt_connection_andor_frame_color=Dark \
        --prompt_spacing=Sparse \
        --icons='Many icons' \
        --transient=Yes
    end
  '';
};

# Set Fish as default shell for user 'vii'
users.users.vii = {
    shell = pkgs.fish;
};

# Fish plugins -----------------------------------------------
environment.systemPackages = with pkgs; [
  fishPlugins.transient-fish   # transient prompts (stick to bottom)
  fishPlugins.tide             # Starship alternative
  fishPlugins.sponge           # Keep history clean from typos
  fishPlugins.plugin-sudope    # Insert sudo - change keybinding: https://github.com/oh-my-fish/plugin-sudope
  # https://github.com/laughedelic/pisces  # Closing brackets 
  fishPlugins.fzf-fish
  # fishPlugins.forgit   # Interactive git commands https://github.com/wfxr/forgit
  # fishPlugins.fish-you-should-use  # Reminder to use defined aliases
  fishPlugins.hydro
  fzf
  zoxide
  eza
  #fishPlugins.grc
  #grc
];


}