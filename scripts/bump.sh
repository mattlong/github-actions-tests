#!/usr/bin/env bash
set -xe

NEW_VERSION=$1

echo "Bumping to v$NEW_VERSION"

sed -i '' -E -e "s/\"version\": \"[^\"]*\"/\"version\": \"$NEW_VERSION\"/g" package.json
git add package.json

git commit -m "Bump to v$1"
git tag "v$1"
