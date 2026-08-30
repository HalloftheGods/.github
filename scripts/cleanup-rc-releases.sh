#!/bin/bash

echo "Fetching tags from remote..."
git fetch --tags

echo "Finding 4-part version tags (e.g., v26.4.21.397)..."
# Get tags that match the 4-part pattern
TAGS_TO_DELETE=$(git tag -l | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+[-.][0-9]+$')

if [ -z "$TAGS_TO_DELETE" ]; then
    echo "No 4-part version tags found."
    exit 0
fi

echo "The following releases and tags will be deleted:"
echo "$TAGS_TO_DELETE"
echo ""

for tag in $TAGS_TO_DELETE; do
    echo "Deleting release for $tag..."
    gh release delete "$tag" --cleanup-tag -y || echo "Failed to delete release $tag, it may not exist. Deleting tag..."
    
    # Just in case the release didn't exist but the tag still does on the remote
    git push origin --delete "$tag" 2>/dev/null || true
    # Delete locally
    git tag -d "$tag" 2>/dev/null || true
done

echo "Cleanup complete!"
