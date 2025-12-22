## Backups

Nix and Home Manager restore the system and most dotfiles, but some personal data and runtime state lives outside this repo. Back up the items below regularly, especially before reinstalling or migrating.

| Item | Path(s) | Why/Notes |
|---|---|---|
| This repo (nixos-config) | `~/nixos-config` (incl. `flake.lock`) | Preserves exact versions and config history; push to remote or archive |
| Neovim config | `~/dev/neovim-config` | Actual editor config (repo symlinked by `modules/home/neovim.nix`) |
| Zoxide database | `${XDG_DATA_HOME:-~/.local/share}/zoxide/db` | Directory frecency learning |
| NBFC config | `~/.config/nbfc.json` | Required by `hosts/laptop/nbfc.nix` |
| SSH | `~/.ssh/` | Keys (`id_ed25519*`), `config`, `known_hosts`, `authorized_keys` |
| GPG (if used) | `~/.gnupg/` | Keys, trustdb; consider `gpg --export-secret-keys` |
| NetworkManager | `/etc/NetworkManager/system-connections/*.nmconnection` | Wi‑Fi, VPN, WireGuard profiles (may contain secrets) |
| WireGuard files (if not NM) | wherever saved (e.g., `~/wg/*.conf`) | Keep original `.conf` plus keys if separate |
| Docker data (if used) | `/var/lib/docker/volumes/` and bind mounts | Persistent container volumes and data dirs |
| Opencode agents | `/home/vii/.config/opencode/agent/` | Opencode agent configurations and settings |

Notes on secrets: Treat SSH/GPG keys and WireGuard/NM exports as sensitive. Store with restricted permissions and never commit them to this repo.

Quick backup script (fish): See `docs/backup.fish`.

To run it:

```fish
fish docs/backup.fish
```

NetworkManager/WireGuard export (optional, may require sudo)

```fish
# Export all connection profiles to the backup directory
set -l BK "$HOME/backups/(date "+%Y-%m-%d_%H-%M-%S")"
mkdir -p $BK/nm
nmcli -t -f NAME connection show | while read -l name
  sudo nmcli connection export "$name" "$BK/nm/(string replace -a ' ' '_' $name).nmconnection"
end
echo "NM profiles exported to: $BK/nm"
```

Restoring is typically just copying files back into place (and for NM, importing with `nmcli connection import`). Always set correct permissions afterward (e.g., `chmod 600` for private keys and `.nmconnection` files containing secrets).
