# modules/home/television.nix
# Television (`tv`) fuzzy finder with fish shell integration and the community aws-profiles
# channel. Shared by all hosts (macOS and Linux).
# Docs: https://alexpasmantier.github.io/television/
_:

{
  programs.television = {
    enable = true;

    # Sources tv's fish integration (Ctrl+T smart autocomplete, Ctrl+R history, tv completions)
    # from interactiveShellInit; equivalent to `tv init fish | source`.
    enableFishIntegration = true;

    # Community channel "aws-profiles" (aws-profiles.toml, unchanged from upstream):
    # https://alexpasmantier.github.io/television/community/channels-unix#aws-profiles
    # Run `tv aws-profiles`; Enter starts a subshell with AWS_PROFILE set (exit to leave it).
    # `aws` is the only runtime requirement; tv does not install it.
    channels.aws-profiles = {
      metadata = {
        name = "aws-profiles";
        description = "List and switch AWS CLI profiles";
        requirements = [
          "aws"
          "grep"
        ];
      };
      source.command =
        "grep '\\[profile' ~/.aws/config 2>/dev/null | sed 's/\\[profile //' | sed 's/\\]//'"
        + " || grep '\\[' ~/.aws/credentials 2>/dev/null | sed 's/\\[//' | sed 's/\\]//'";
      preview.command = "aws configure list --profile '{}' 2>/dev/null";
      keybindings.enter = "actions:export";
      ui.preview_panel.size = 40;
      actions.export = {
        description = "Export the selected profile (sets AWS_PROFILE)";
        command = "export AWS_PROFILE={} && echo \"AWS_PROFILE set to {}\" && $SHELL";
        mode = "execute";
      };
    };
  };
}
