#!/usr/bin/env fish
# Workaround for corrupted EFI NVRAM causing bootctl to crash
# Usage: sudo fish docs/nixos-rebuild-workaround.fish

set -l FLAKE ".#laptop"

echo "🔧 Building and activating configuration (without bootloader)..."
sudo nixos-rebuild test --flake $FLAKE
or begin
    echo "❌ Build failed"
    exit 1
end

# Get the new system path
set -l NEW_SYSTEM (readlink -f /run/current-system)
echo "✅ Activated: $NEW_SYSTEM"

# Set as system profile
echo "📝 Setting as system profile..."
sudo nix-env --profile /nix/var/nix/profiles/system --set $NEW_SYSTEM

# Get generation number
set -l GEN_NUM (basename (readlink /nix/var/nix/profiles/system) | string replace 'system-' '' | string replace -- '-link' '')
echo "📦 Generation: $GEN_NUM"

# Get previous generation for template
set -l PREV_GEN (math $GEN_NUM - 1)
set -l PREV_ENTRY "/boot/loader/entries/nixos-generation-$PREV_GEN.conf"
set -l NEW_ENTRY "/boot/loader/entries/nixos-generation-$GEN_NUM.conf"

if test -f $PREV_ENTRY
    echo "📄 Creating boot entry from generation $PREV_GEN template..."
    
    # Extract store path hash from new system
    set -l NEW_HASH (basename $NEW_SYSTEM | string split '-' | head -1)
    set -l OLD_HASH (grep -oP 'init=/nix/store/\K[^-]+' $PREV_ENTRY)
    
    sudo cp $PREV_ENTRY $NEW_ENTRY
    sudo sed -i "s/Generation $PREV_GEN/Generation $GEN_NUM/g" $NEW_ENTRY
    sudo sed -i "s/$OLD_HASH/$NEW_HASH/g" $NEW_ENTRY
    
    # Update default
    sudo sed -i "s/nixos-generation-$PREV_GEN/nixos-generation-$GEN_NUM/" /boot/loader/loader.conf
    
    echo "✅ Boot entry created and set as default"
    echo ""
    echo "Current boot config:"
    cat /boot/loader/loader.conf
else
    echo "⚠️  Previous boot entry not found: $PREV_ENTRY"
    echo "   You may need to manually create the boot entry"
end

echo ""
echo "🎉 Done! Your system will boot into generation $GEN_NUM on next reboot."
