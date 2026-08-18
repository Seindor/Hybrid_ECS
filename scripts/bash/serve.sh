#!/bin/sh

set -e

if [ ! -d "roblox_packages" ]; then
    pesde install
fi

rm -rf out
rojo sourcemap default.project.json -o sourcemap.json

ROBLOX_DEV=true darklua process --config .darklua.json --watch src/ out/ \
    & rojo serve build.project.json \
    & rojo sourcemap default.project.json -o sourcemap.json --watch 
    