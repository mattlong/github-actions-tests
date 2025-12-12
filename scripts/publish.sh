#!/usr/bin/env bash
set -xe

TAG_FLAG=''
if [ ! -z "$1" ]; then
  TAG_FLAG="--tag $1"
  echo "Using tag: $TAG_FLAG"
fi

npm publish --provenance --access public $TAG_FLAG
