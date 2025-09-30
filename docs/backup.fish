#!/usr/bin/env fish
# Backup user-level state not covered by declarative configuration.
# Creates a timestamped directory under ~/backups and collects key files.
# Safe defaults; adjust as needed.

set -l ts (date "+%Y-%m-%d_%H-%M-%S")
set -l BK "$HOME/backups/$ts"
mkdir -p $BK

# Repo snapshots (optional if already pushed)
if test -d "$HOME/nixos-config"
  tar -czf $BK/nixos-config.tar.gz -C $HOME nixos-config
end
if test -d "$HOME/dev/neovim-config"
  tar -czf $BK/neovim-config.tar.gz -C $HOME/dev neovim-config
end

# Shell state
if test -f "$HOME/.config/fish/fish_variables"
  cp "$HOME/.config/fish/fish_variables" $BK/
end
if test -f "$HOME/.local/share/fish/fish_history"
  cp "$HOME/.local/share/fish/fish_history" $BK/
end

# Zoxide DB
set -l data_home $XDG_DATA_HOME
if test -z "$data_home"
  set data_home "$HOME/.local/share"
end
set -l ZOX "$data_home/zoxide/db"
if test -f $ZOX
  cp $ZOX $BK/zoxide.db
end

# Neovim runtime state (optional)
if test -d "$HOME/.local/state/nvim"
  tar -czf $BK/nvim-state.tar.gz -C $HOME/.local/state nvim
end
if test -d "$HOME/.local/share/nvim"
  tar -czf $BK/nvim-share.tar.gz -C $HOME/.local/share nvim
end

# NBFC (laptop only)
if test -f "$HOME/.config/nbfc.json"
  cp "$HOME/.config/nbfc.json" $BK/
end

# SSH (sensitive)
if test -d "$HOME/.ssh"
  tar -czf $BK/ssh.tar.gz -C $HOME .ssh
  chmod 600 $BK/ssh.tar.gz
end

# GPG (sensitive; prefer proper key export if you intend to import elsewhere)
if test -d "$HOME/.gnupg"
  tar -czf $BK/gnupg.tar.gz -C $HOME .gnupg
  chmod 600 $BK/gnupg.tar.gz
end

# Docker named volumes (optional; may be large)
if test -d "/var/lib/docker/volumes"
  echo "Note: Docker volumes can be large; skipping by default."
  # Uncomment to enable:
  # sudo tar -czf $BK/docker-volumes.tar.gz -C /var/lib/docker volumes
end

printf "Backup written to: %s\n" $BK
