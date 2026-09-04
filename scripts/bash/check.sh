#!/bin/sh

set -e

stylua ./src \
    & selene ./src \
    & luau-lsp analyze --definitions:@roblox=./globalTypes.d.luau --ignore "**/roblox_packages/**" --ignore "**/roblox_server_packages/**" --ignore "**/Internal/Signals.luau" --sourcemap ./sourcemap.json --base-luaurc ./.luaurc --no-strict-dm-types --flag:LuauSolverV2=true ./src
