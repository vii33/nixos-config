# ./modules/default.nix
{ config, pkgs, ... }:

{
# Enable Fish shell
programs.fish.enable = true;
# Set Fish as the default shell (not everywhere otherwise will lead to low level problems)
# programs.bash = {
#   enable = true;
#   initExtra = ''
#     if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
#     then
#       shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
#       exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
#     fi
#   '';
# };

users.users.vii = {
    shell = pkgs.fish;
};

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