#!/bin/sh

echo "formatting all *.nix files..."

for file in $(find . -name "*.nix"); do
    echo "formatting $file..."
    nix fmt "$file"
done

echo "formatting complete."
