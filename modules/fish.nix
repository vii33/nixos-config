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

}