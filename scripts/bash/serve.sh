#!/bin/sh

set -e

if [ ! -d "roblox_packages" ]; then
    pesde install
fi

rm -rf out
rojo sourcemap default.project.json -o sourcemap.json

# первый проход синхронно: out/ точно существует, ошибки видны сразу
ROBLOX_DEV=true darklua process --config .darklua.json src/ out/

trap 'kill $(jobs -p) 2>/dev/null' EXIT INT TERM

ROBLOX_DEV=true darklua process --config .darklua.json --watch src/ out/ &
rojo serve build.project.json &
rojo sourcemap default.project.json -o sourcemap.json --watch &

wait