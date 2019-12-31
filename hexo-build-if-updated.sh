#!/bin/bash

set -e

if [[ -n "$(git diff --name-status HEAD~1...HEAD blog)" ]]; then
  cp blog/themes/_config.yml blog/themes/symphony/
  npx hexo --cwd blog generate
fi
