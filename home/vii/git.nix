# profiles/home/git.nix
{ config, pkgs, lib, gitIdentity ? "personal", ... }:

let
  haveWorkGitSecret =
    gitIdentity == "work"
    && lib.hasAttrByPath [ "sops" "secrets" "git_work_gitconfig" ] config;
in
{
  # Home Manager configures Git via XDG (~/.config/git/config).
  # Keep ~/.gitconfig unmanaged so GUI tools like GitHub Desktop can still
  # use `git config --global` and write their legacy global settings.
  home.activation.ensureWritableGitConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    gitconfig="$HOME/.gitconfig"
    gitconfig_include="path = ~/.config/git/config"

    if [ -L "$gitconfig" ]; then
      $VERBOSE_ECHO "Removing read-only $gitconfig symlink"
      rm "$gitconfig"
    fi

    if [ ! -e "$gitconfig" ]; then
      $VERBOSE_ECHO "Creating writable $gitconfig include stub"
      cat > "$gitconfig" <<'EOF'
[include]
	path = ~/.config/git/config
EOF
    elif ! grep -Fq "$gitconfig_include" "$gitconfig"; then
      $VERBOSE_ECHO "Adding XDG Git include to $gitconfig"
      printf '\n[include]\n\tpath = ~/.config/git/config\n' >> "$gitconfig"
    fi
  '';

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
