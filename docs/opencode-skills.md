# OpenCode skills

Read when: installing, updating, or troubleshooting globally available agent skills.

## Declarative installation

Matt Pocock's [skills](https://github.com/mattpocock/skills) are pinned by the
`mattpocock-skills` non-flake input in `flake.lock`. Home Manager installs the
`engineering` and `productivity` collections, including supporting files, under:

```text
~/.config/opencode/skills/mattpocock/engineering/
~/.config/opencode/skills/mattpocock/productivity/
```

OpenCode discovers `SKILL.md` files recursively there without an extra plugin or
JSON configuration. The shared `modules/home/opencode-skills.nix` module is
imported only by the Linux user configuration. Skills are available across
projects for that user, not automatically for every system user. Remote OpenCode
servers need this configuration activated on the server itself.

Only the two published collections are included. Upstream `misc`, `in-progress`,
and `deprecated` directories are intentionally excluded. Nix store files are
read-only; add personal skills alongside `mattpocock`, or change the Nix source
rather than editing installed files.

Vercel's `npx skills` CLI is an alternative imperative installer, not a runtime
dependency. Do not also install this collection with the CLI: duplicate skill
names can conflict, and CLI updates do not update the flake's pinned revision.

## Activate and use

Apply the normal NixOS configuration on the target Linux
machine (see [Linux](linux.md)). Existing OpenCode settings
and `AGENTS.md` are not modified by this module.

Quit and restart OpenCode after activation. If using an OpenCode server, restart
the server as well; reconnecting the client is not sufficient.

Ask OpenCode to load `setup-matt-pocock-skills` once per project to configure
project-specific conventions. Other skills can be requested by name, for example
"Use the tdd skill" or "Use grill-me". The upstream setup skill may propose
project documentation changes; review those separately from this installation.

## Update

```fish
nix flake update mattpocock-skills
git diff -- flake.lock
nix flake check --no-build
```

Review upstream changes, apply the target configuration again, and restart
OpenCode. Rollbacks restore the previous pinned collection with the previous
configuration generation. No npm package or background updater is needed.
