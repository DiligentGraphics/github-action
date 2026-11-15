#!/usr/bin/env bash
set -euo pipefail

# The module owns test selection, browser sessions, and result collection. Pass
# Chrome directly: a shell wrapper cannot be launched by Python on Windows.
MODE="$1"
RUNNER="$2"
MODULE="$3"
OUTPUT_DIR="$4"
PYTHON=python3
# A nonempty array also works with macOS Bash 3.2 and set -u.
RUNNER_ARGS=(--mode "$MODE")
if [[ -n "${INPUT_BROWSER:-}" ]]; then
    RUNNER_ARGS+=(--browser "$INPUT_BROWSER")
fi

if [[ "${RUNNER_OS:-}" == "Windows" || "$OSTYPE" == msys* ]]; then
    PYTHON=python
fi

if [[ "$MODE" == "wgpu" ]]; then
    if [[ "${RUNNER_OS:-}" == "Windows" || "$OSTYPE" == msys* ]]; then
        # Windows Chrome queries ANGLE's D3D11 device during adapter selection.
        # Use WARP for ANGLE, while WebGPU itself uses SwiftShader below.
        RUNNER_ARGS+=(--browser-arg=--use-angle=d3d11-warp)
    else
        # Linux canvas presentation needs the Vulkan compositor as well as the
        # SwiftShader WebGPU adapter.
        RUNNER_ARGS+=(--browser-arg=--use-angle=swiftshader
                       --browser-arg=--enable-features=Vulkan
                       --browser-arg=--use-vulkan=swiftshader
                       --browser-arg=--disable-vulkan-surface)
    fi

    RUNNER_ARGS+=(--browser-arg=--enable-unsafe-webgpu
                   --browser-arg=--enable-unsafe-swiftshader
                   --browser-arg=--use-webgpu-adapter=swiftshader)
fi

"$PYTHON" -B "$RUNNER" --module "$MODULE" \
    "${RUNNER_ARGS[@]}" --filter="${INPUT_FILTER:-*}" --output "$OUTPUT_DIR"
