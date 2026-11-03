# modules/home/television.nix
# Television (`tv`) fuzzy finder with fish shell integration. Shared by all hosts.
# Host-specific channels live in their own modules, e.g. television-aws-profiles.nix (work only).
# Docs: https://alexpasmantier.github.io/television/
_:

{
  programs.television = {
    enable = true;

    # Sources tv's fish integration (Ctrl+T smart autocomplete, Ctrl+R history, tv completions)
    # from interactiveShellInit; equivalent to `tv init fish | source`.
    enableFishIntegration = true;
  };
}
