#!/bin/bash

# if [[ -n "$(git diff --name-status HEAD~1...HEAD blog)" ]]; then
cd blog
npm install
npx hexo generate
# fi