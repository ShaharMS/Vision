#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: bash build-native-drawing.sh <hashlink-include-directory> [output-directory]" >&2
    exit 2
fi

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source="$root/src/vision/formats/__internal"
hashlink="$1"
output="${2:-$root/bin/native-drawing}"
hxcpp="$(haxelib libpath hxcpp)"

system_link=()
case "$(uname -s)" in
    Linux) link=(-shared); system_link=(-ldl) ;;
    Darwin) link=(-dynamiclib -undefined dynamic_lookup) ;;
    *) echo "Use build-native-drawing.ps1 on Windows." >&2; exit 2 ;;
esac

read -ra sdl_compile <<< "$(pkg-config --cflags sdl2)"
read -ra sdl_link <<< "$(pkg-config --libs sdl2)"
mkdir -p "$output"

"${CC:-cc}" -O2 -std=c11 -fPIC "${sdl_compile[@]}" -c "$source/NativeImageIO.sdl.c" -o "$output/vision_window.o"
"${CC:-cc}" -O2 -std=c11 -fPIC -c "$source/NativeImageOperations.c" -o "$output/vision_operations.o"
"${CC:-cc}" -O2 -std=c11 -fPIC "${link[@]}" -I"$hashlink" "$source/NativeImageIO.hl.c" \
    "$output/vision_window.o" "$output/vision_operations.o" "${sdl_link[@]}" -o "$output/vision_native.hdll"
"${CXX:-c++}" -O2 -std=c++11 -fPIC "${link[@]}" -I"$hxcpp/include" "$source/NativeImageIO.cpp" \
    "$output/vision_window.o" "$output/vision_operations.o" "${sdl_link[@]}" "${system_link[@]}" -o "$output/vision_native.ndll"
