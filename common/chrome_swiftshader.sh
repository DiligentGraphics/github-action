#!/usr/bin/env bash
set -euo pipefail

# Both browser test actions use this wrapper. The module's test harness owns
# the browser session; this script only selects Chrome and its software backend.
BROWSER="${DILIGENT_BROWSER_EXECUTABLE:-}"
if [[ -z "$BROWSER" ]]; then
    for CANDIDATE in google-chrome google-chrome-stable chromium chromium-browser; do
        if BROWSER="$(command -v "$CANDIDATE")"; then
            break
        fi
    done
fi
if [[ -z "$BROWSER" ]]; then
    echo "Chrome/Chromium was not found; set the action's browser input." >&2
    exit 1
fi

# Canvas presentation needs the Vulkan compositor as well as a SwiftShader
# WebGPU adapter. Keep the same backend for Core readback and Radient rendering.
exec "$BROWSER" \
    --use-angle=swiftshader \
    --enable-features=Vulkan \
    --use-vulkan=swiftshader \
    --disable-vulkan-surface \
    --enable-unsafe-webgpu \
    --enable-unsafe-swiftshader \
    --use-webgpu-adapter=swiftshader \
    "$@"
