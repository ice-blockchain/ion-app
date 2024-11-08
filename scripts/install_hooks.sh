#!/bin/bash

GIT_DIR=$(git rev-parse --git-dir)

echo "Installing hooks..."
# this command creates symlink to our pre-commit script
rm -f $GIT_DIR/hooks/pre-commit
rm -f $GIT_DIR/hooks/pre-push

cp scripts/pre_push.sh $GIT_DIR/hooks/pre-push
echo "Done!" 