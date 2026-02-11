#!/usr/bin/env fish
# Sync LazyVim plugin specs from this repo to ~/.config/nvim/lua/plugins/

set SPECS_DIR (dirname (status --current-filename))/lua-specs
set TARGET_DIR ~/.config/nvim/lua/plugins

# Files to exclude from syncing (add more as needed)
set EXCLUDED_FILES \
    init.lua \
    mason-disabled.lua

# Create target directory if it doesn't exist
mkdir -p $TARGET_DIR

# Copy all .lua files except excluded ones
for file in $SPECS_DIR/*.lua
    set filename (basename $file)
    
    # Skip if filename is in excluded list
    if contains $filename $EXCLUDED_FILES
        echo "Skipping $filename (excluded)"
        continue
    end
    
    # Skip if file already exists in target
    if test -f $TARGET_DIR/$filename
        echo "Skipping $filename (already exists)"
        continue
    end
    
    cp $file $TARGET_DIR/$filename
    echo "Copied $filename → $TARGET_DIR/"
end

echo "✓ LazyVim specs synced successfully"
