#!/bin/bash

jekyll build --incremental
current_dir=$(pwd)
cd _site/
git status
echo "Continue (ctrl-c for no)?"
read addAll
git commit -m "$@"
git push
cd $current_dir