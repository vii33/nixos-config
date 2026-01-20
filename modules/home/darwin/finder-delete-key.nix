# ./modules/home/darwin/finder-delete-key.nix
# Maps the forward delete key to "Move to Trash" in Finder
# This makes the delete key behave like it does in Windows Explorer
{ config, pkgs, ... }:

{
  # Add Finder keyboard shortcut to map Delete key to "Move to Trash"
  home.activation.finderDeleteKey = config.lib.dag.entryAfter ["writeBoundary"] ''
    # Set Finder keyboard shortcut for Delete key to move files to trash
    $DRY_RUN_CMD defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Move to Trash" -string "@\U007F"
    
    # Restart Finder to apply changes
    $DRY_RUN_CMD killall Finder 2>/dev/null || true
  '';
}
