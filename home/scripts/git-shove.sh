#!/usr/bin/env bash

# Opens the github page for the current git repository in your browser
# git@github.com:jasonneylon/dotfiles.git
# https://github.com/jasonneylon/dotfiles/

message=${1}
path=${2:-.}

git -C $path rev-parse 2>/dev/null || { echo "This is not a git repository."; exit 1; }

if [ -z "$message" ]; then
  read -p "Enter commit message: " message
fi

# Add all updates to git versioned files
echo "Adding and committing all changed files..."
git add -u

# Commit the files with the supplied message
git commit -m "$message" || exit 1

echo "Pushing files to repo $3 $4"
# Push to repo and branch
git push $3 $4
