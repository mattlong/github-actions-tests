#!/usr/bin/env bash
set -xe

NEW_VERSION=$1

echo "Bumping to v$NEW_VERSION"

npm version "$NEW_VERSION"
git add package.json package-lock.json

git commit -m "Bump to v$1"
git tag "v$1"
