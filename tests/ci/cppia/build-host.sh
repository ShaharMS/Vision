#!/usr/bin/env bash
set -euo pipefail

# Keep the source revision and patch coupled. This script never uses a moving branch.
HXCPP_REVISION=ceb70d040f0792f004ccf1ed7eb6fcea01d7f3ff
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
export HXCPP_NONINTERACTIVE=1
export HXCPP_COMPILE_THREADS=${HXCPP_COMPILE_THREADS:-4}

if [[ $# -gt 1 || ( $# -eq 1 && "$1" != "--use-existing" ) ]]; then
    echo "Usage: build-host.sh [--use-existing]" >&2
    exit 2
fi
if [[ $# -eq 0 ]]; then
    haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp "$HXCPP_REVISION"
fi
HXCPP_PATH=$(haxelib path hxcpp | sed -n '1p' | tr -d '\r')
if [[ "$(git -C "$HXCPP_PATH" rev-parse HEAD)" != "$HXCPP_REVISION" ]]; then
    echo "The cppia compatibility patch requires hxcpp $HXCPP_REVISION." >&2
    exit 1
fi
PATCH_FILE="$SCRIPT_DIR/hxcpp-array-compat.patch"
if git -C "$HXCPP_PATH" apply --ignore-space-change --reverse --check "$PATCH_FILE" 2>/dev/null; then
    echo "cppia array compatibility patch is already applied."
else
    git -C "$HXCPP_PATH" apply --ignore-space-change --check "$PATCH_FILE"
    git -C "$HXCPP_PATH" apply --ignore-space-change "$PATCH_FILE"
fi
# A Git hxcpp checkout lacks hxcpp.n and otherwise reaches an interactive prompt.
(cd "$HXCPP_PATH/tools/hxcpp" && haxe compile.hxml)
(cd "$HXCPP_PATH/project" && haxe compile-cppia.hxml)
echo "Built patched cppia interpreter host from hxcpp $HXCPP_REVISION."
