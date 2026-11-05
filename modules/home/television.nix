# modules/home/television.nix
# Television (`tv`) fuzzy finder with fish shell integration and custom channels.
# Shared by macOS and Linux.
# Docs: https://alexpasmantier.github.io/television/
_:

{
  programs.television = {
    enable = true;

    # Sources tv's fish integration (Ctrl+T smart autocomplete, Ctrl+R history, tv completions)
    # from interactiveShellInit; equivalent to `tv init fish | source`.
    enableFishIntegration = true;

    # Search from / without ignore rules; skip virtual filesystems, not disk files.
    # fd and bat are installed by modules/system/common_all.nix on both platforms.
    channels.files-all = {
      metadata = {
        name = "files-all";
        description = "Search files across the filesystem, including hidden and ignored files";
        requirements = [
          "fd"
          "bat"
        ];
      };
      source.command =
        "fd --type f --hidden --no-ignore --absolute-path --color never"
        + " --exclude /dev --exclude /proc --exclude /sys -- . / 2>/dev/null";
      # Escape apostrophes before interpolation into the preview shell command.
      preview.shell = "bash";
      preview.command =
        "bat --color=always --style=numbers --line-range=:200 --" + " '{replace:s/'/'\"'\"'/g}'";
    };

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
