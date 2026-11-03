# modules/home/television-aws-profiles.nix
# Community channel "aws-profiles" for television, plus an `awsp` fish function. Work host only.
# Needs modules/home/television.nix (programs.television) to be enabled as well.
# Docs: https://alexpasmantier.github.io/television/community/channels-unix#aws-profiles
_:

{
  # `aws` is the only runtime requirement; tv does not install it.
  programs.television.channels.aws-profiles = {
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
    ui.preview_panel.size = 40;
    # No `enter` action: the upstream one only exports AWS_PROFILE in a subshell. Enter just
    # prints the profile name, and the `awsp` function below sets it in the *current* shell.
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
