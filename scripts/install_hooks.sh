#!/bin/bash

GIT_DIR=$(git rev-parse --git-dir)

echo "Installing hooks..."
# this command creates symlink to our pre-commit script
rm -f $GIT_DIR/hooks/pre-commit
cp scripts/pre_commit.sh $GIT_DIR/hooks/pre-commit
echo "Done!" 