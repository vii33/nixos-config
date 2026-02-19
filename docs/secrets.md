# Secrets (sops-nix)

This repo uses **sops-nix** to manage secrets (API keys, tokens, passwords) without putting them in
Nix expressions (which would end up in the Nix store).

## Model

- You commit **encrypted** secrets files to the repo (SOPS format).
- On `nixos-rebuild` / `darwin-rebuild` / `home-manager switch`, secrets are **decrypted at
  activation time** and written to plaintext files with strict permissions.
- Shell env vars are exported **at runtime** by reading those plaintext files.

## Setup (one-time per machine)

1. Generate an age key:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt
```

If `age-keygen` is not in your PATH yet, run it via Nix:

```bash
mkdir -p ~/.config/sops/age
nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```

On **macOS**, the `sops` CLI looks for age identities at:

- `~/Library/Application Support/sops/age/keys.txt`

This repo (and sops-nix config) uses `~/.config/sops/age/keys.txt`, so either:

```bash
# Use the repo key location explicitly (works in fish/bash/zsh)
env SOPS_AGE_KEY_FILE=$HOME/.config/sops/age/keys.txt sops secrets/secrets.yaml
```

or create a symlink to the macOS default location:

```bash
mkdir -p "$HOME/Library/Application Support/sops/age"
ln -sf "$HOME/.config/sops/age/keys.txt" "$HOME/Library/Application Support/sops/age/keys.txt"
```

2. Configure SOPS for this repo:

   - The SOPS config file should live at the **repo root**: `./.sops.yaml` (next to `flake.nix`).
     This repo already includes one; you just need to edit it.
   - SOPS discovers config by walking up parent directories from the file you're editing, so keeping
     `./.sops.yaml` at the root ensures it applies to files under `./secrets/`.

   Edit `./.sops.yaml` and replace the placeholder `age1...` recipient with your public key.

3. Create an encrypted secrets file:

```bash
mkdir -p secrets
cp secrets/secrets.yaml.example secrets/secrets.yaml
sops --encrypt --in-place secrets/secrets.yaml
```

If `sops` is not in your PATH yet, run it via Nix:

```bash
nix shell nixpkgs#sops -c sops --encrypt --in-place secrets/secrets.yaml
```

4. Edit secrets:

```bash
sops secrets/secrets.yaml
```

If `sops` is not in your PATH yet, run it via Nix:

```bash
nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

If you see an error like “failed to load age identities”, point `sops` at your age key file:

```bash
env SOPS_AGE_KEY_FILE=$HOME/.config/sops/age/keys.txt nix shell nixpkgs#sops -c sops secrets/secrets.yaml
```

## Adding a new machine / rekeying

1. Generate a new machine age key (same as setup step 1).
2. Add the new **public** key to `.sops.yaml` recipients.
3. Rekey existing files:

```bash
sops updatekeys secrets/secrets.yaml
```

If `sops` is not in your PATH yet, run it via Nix:

```bash
nix shell nixpkgs#sops -c sops updatekeys secrets/secrets.yaml
```

## Rotation

When a secret must be rotated:

1. Rotate it at the provider (e.g. GitHub/Anthropic/etc).
2. Update `secrets/secrets.yaml` using `sops secrets/secrets.yaml`.
3. Rebuild/switch so the decrypted files are updated.

## Important

- If a secret ever landed in git history (even briefly), rotate it; removing it from the working tree
  does **not** remove it from history.
