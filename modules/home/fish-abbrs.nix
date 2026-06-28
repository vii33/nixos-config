{
  # Terminal
  tree = "eza --tree --level 2 --git-ignore";
  ezatree = "eza -T -a -L 2 --icons";
  ezal = "eza -lah --icons --git --group-directories-first --header";
  # Auto-run pane commands when resurrecting a session.
  zz = "zellij attach -c --forget main";
  zellijkill = "zellij kill-all-sessions -y; zellij delete-all-sessions -y";
  zzk = "zellij kill-all-sessions -y; zellij delete-all-sessions -y";

  # NixOS
  nixdry = "nh os dry-run ~/repos/nixos-config/flake.nix -H laptop";
  nixswitch = "nh os switch ~/repos/nixos-config/ -H laptop";
  nixclean1 = "nh clean all --keep-since 3d --keep 3";
  nixclean2 = "sudo nix-collect-garbage";
  nixsearch = "nh search ";
  sopsedit = "env SOPS_AGE_KEY_FILE=\"$HOME/.config/sops/age/keys.txt\" nix shell nixpkgs#sops -c sops \"$HOME/repos/nixos-config/secrets/secrets.yaml\"";

  # Applications
  nv = "nvim";
  oc = "opencode";
  ocg = "opencode -m openai/gpt-5.5";
  ocp = "opencode -m opencode/big-pickle";
  oca =
    "if test -f \"$HOME/.config/fish/conf.d/90-sops-secrets.fish\"; "
    + "source \"$HOME/.config/fish/conf.d/90-sops-secrets.fish\"; end; "
    + "if test -n \"$OPENCODE_SERVER_PASSWORD\"; "
    + "opencode attach http://localhost:4096 --password \"$OPENCODE_SERVER_PASSWORD\" --dir \"$PWD\"; "
    + "else; echo \"OPENCODE_SERVER_PASSWORD is not set\"; end";
  occ =
    "if test -f \"$HOME/.config/fish/conf.d/90-sops-secrets.fish\"; "
    + "source \"$HOME/.config/fish/conf.d/90-sops-secrets.fish\"; end; "
    + "if test -n \"$OPENCODE_SERVER_PASSWORD\"; "
    + "opencode attach http://localhost:4096 --password \"$OPENCODE_SERVER_PASSWORD\" --dir \"$PWD\"; "
    + "else; echo \"OPENCODE_SERVER_PASSWORD is not set\"; end";
  lg = "lazygit";
  cop = "copilot";
  coclaude = "copilot --model claude-sonnet-4.5";
  cocodex = "copilot --model gpt-5.3-codex";
  ocs =
    "if test -f \"$HOME/.config/fish/conf.d/90-sops-secrets.fish\"; "
    + "source \"$HOME/.config/fish/conf.d/90-sops-secrets.fish\"; end; "
    + "if test -n \"$OPENCODE_SERVER_PASSWORD\"; "
    + "opencode serve --hostname 0.0.0.0 --port 4096; "
    + "else; echo \"OPENCODE_SERVER_PASSWORD is not set\"; end";
  bs = "pybonsai -w 0.04";

  # Mac OS
  # Rebuild Home Manager, then detach and let a helper process remove the
  # current Zellij session so the next attach starts fresh.
  hmswitch =
    "home-manager switch --flake ~/repos/nixos-config/.#work --impure; and begin; "
    + "set -l session_name main; "
    + "if set -q ZELLIJ_SESSION_NAME; set session_name $ZELLIJ_SESSION_NAME; "
    + "nohup fish -c \"sleep 1; zellij kill-session '$session_name' >/dev/null 2>&1; "
    + "sleep 1; zellij delete-session '$session_name' >/dev/null 2>&1\" "
    + "</dev/null >/dev/null 2>&1 &; disown; zellij action detach; "
    + "else; zellij kill-session $session_name; sleep 1; "
    + "zellij delete-session $session_name; end; end";
  workswitch = "cd ~/repos/nixos-config; and darwin-rebuild build --flake .#work --impure; and sudo env \"PATH=$PATH\" ./result/activate";
  proxyrestart = "launchctl kickstart -k -p \"gui/$(id -u)/cc.colorto.proxydetox\"";

  # Kitty
  kittyreload = "kitty @ load-config";
}
