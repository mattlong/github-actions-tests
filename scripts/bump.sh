#!/usr/bin/env bash

echo $1 > version.txt
git add version.txt
git commit -m "Bump to v$1"
