#!/usr/bin/env bash
set -xe

NEW_VERSION=$1

echo "Bumping to v$NEW_VERSION"

echo $NEW_VERSION > version.txt
git add version.txt

sed -i '' -E -e "s/VERSION = '[^\']*'/VERSION = '$NEW_VERSION'/g" version.js
git add version.js

sed -i '' -E -e "s/\"version\": \"[^\"]*\"/\"version\": \"$NEW_VERSION\"/g" package.json
git add package.json

git commit -m "Bump to v$1"
git tag "v$1"
