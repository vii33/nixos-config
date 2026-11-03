# modules/home/television.nix
# Television (`tv`) fuzzy finder with fish shell integration and community channels.
# Docs: https://alexpasmantier.github.io/television/
{ pkgs, ... }:

{
  programs.television = {
    enable = true;

    # Sources tv's fish integration (Ctrl+T smart autocomplete, Ctrl+R history, tv completions)
    # from interactiveShellInit; equivalent to `tv init fish | source`.
    enableFishIntegration = true;

    # Community channel "aws-profiles" (aws-profiles.toml from the unix channel list).
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
      # Enter prints the profile name; the `awsp` fish function below uses it to set
      # AWS_PROFILE in the *current* shell (the upstream action only exports it in a subshell).
      ui.preview_panel.size = 40;
    };
  };

  programs.fish.functions.awsp = {
    description = "Pick an AWS CLI profile with television and export AWS_PROFILE";
    body = ''
      set -l profile (tv aws-profiles)
      or return

      if test -n "$profile"
        set -gx AWS_PROFILE $profile
        echo "AWS_PROFILE set to $profile"
      end
    '';
  };
}
