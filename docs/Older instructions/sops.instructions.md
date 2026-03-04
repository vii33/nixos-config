---
applyTo: '{secrets/secrets*.yaml,docs/secrets.md}'
---

# SOPS Editing SOP (Repo-Specific)

When changing secrets in this repo, use these commands and rules to avoid breaking `secrets/secrets.yaml`.

## Required command pattern

Use `sops --set` with `-i` on the real repo file:

```bash
env SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops --set '["no_proxy"] "localhost,127.0.0.1,.bmwgroup.net,aws.cloud.bmw,azure.cloud.bmw"' \
  -i secrets/secrets.yaml
```

## Rules

1. Run from the repository root so `./.sops.yaml` is discovered correctly.
2. Do **not** use `sops set ...` for this workflow; use `sops --set ... -i`.
3. Do **not** edit temp copies outside `secrets/` (creation rules may fail with `no matching creation rules found`).
4. Do **not** redirect `sops` stdout back into `secrets/secrets.yaml`; prefer in-place `-i`.

## Validation

Validate a single key after update:

```bash
env SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops decrypt --extract '["no_proxy"]' secrets/secrets.yaml
```
