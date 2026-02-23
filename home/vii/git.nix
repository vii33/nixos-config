# profiles/home/git.nix
{ config, pkgs, lib, gitIdentity ? "personal", ... }:

let
  haveWorkGitSecret =
    gitIdentity == "work"
    && lib.hasAttrByPath [ "sops" "secrets" "git_work_gitconfig" ] config;
in
{
  # Home Manager configures Git via XDG (~/.config/git/config). Keep ~/.gitconfig neutral so it
  # doesn't override the declarative config (and so the work identity can win on the work host).
  home.file.".gitconfig" = {
    force = true;
    text = ''
      # Managed by Home Manager. Git config lives in ~/.config/git/config.
    '';
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    includes = lib.optionals haveWorkGitSecret [
      { path = config.sops.secrets.git_work_gitconfig.path; }
    ];
    settings =
      {
        pull.rebase = true;
      }
      // lib.optionalAttrs (gitIdentity == "personal") {
        user = {
          name = "vii33";
          email = "1887246+vii33@users.noreply.github.com";
        };
      };
  };
}
