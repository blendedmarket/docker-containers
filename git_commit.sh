#!/bin/bash

# Step 1: Add files interactively
echo "Do you want to add all changes? (y/n)"
read add_all

if [ "$add_all" = "y" ]; then
    echo "Running: git add ."
    git add .
else
    echo "Enter the files to add (space-separated):"
    read files
    echo "Running: git add $files"
    git add $files
fi

# Step 2: Enter commit message
echo "Enter your commit message:"
read commit_message

echo "Running: git commit -m \"$commit_message\""
git commit -m "$commit_message"

# Step 3: Show commit summary
echo "Commit summary (last commit):"
git log -1 --stat

# Step 4: Offer to push
echo "Do you want to push to the current branch? (y/n)"
read do_push

current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$do_push" = "y" ]; then
    echo "Running: git push origin $current_branch"
    git push origin "$current_branch"
else
    echo "If you want to push later, use:"
    echo "git push origin $current_branch"
fi

echo "Done!"